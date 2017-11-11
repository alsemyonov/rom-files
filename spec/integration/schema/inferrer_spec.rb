# frozen_string_literal: true

require 'rom/files/schema/inferrer'
require 'shared/media_files'

RSpec.describe 'Schema inference for common file types' do
  include_context 'media files'

  let(:relation) { container.relations[relation_name] }
  let(:schema) { relation.schema }
  let(:source) { schema.name }
  let(:relation_name) { dataset }

  describe 'inferring attributes' do
    before do
      name = dataset
      configuration.relation(relation_name) { schema(name, infer: true) }
    end

    context 'for simple file set' do
      let(:dataset) { :media }

      it 'can infer attributes for dataset' do
        expect(schema[:__FILE__].source).to eql(source)
        expect(schema[:__FILE__].type.primitive).to be(Pathname)
      end
    end

    context 'for MIME-typed file set' do
      let(:relation_name) { :texts }
      let(:dataset) { 'text/plain' }

      it 'can infer attributes for dataset' do
        expect(schema[:__FILE__].source).to eql(source)
        expect(schema[:__FILE__].type.primitive).to be(Pathname)

        expect(schema[:__contents__].source).to eql(source)
        expect(schema[:__contents__].meta[:__contents__]).to be(true)
        expect(schema[:__contents__].type.primitive).to be(String)
      end
    end

    xcontext 'for a table with FKs' do
      let(:dataset) { :tasks }
      let(:source) { ROM::Relation::Name[:tasks] }

      it 'can infer attributes for dataset' do |_ex|
        expect(schema[:id].source).to eql(source)
        expect(schema[:id].type.primitive).to be(Integer)

        expect(schema[:title].source).to eql(source)
        # TODO: is this supposed to store limit here?
        # expect(schema[:title].meta[:limit]).to eql(255)
        expect(schema[:title].unwrap.type.primitive).to be(String)

        expect(schema[:user_id].source).to eql(source)
        expect(schema[:user_id]).to be_foreign_key
        expect(schema[:user_id].meta[:index]).to be(true)
        expect(schema[:user_id].target).to eql(:media)
        expect(schema[:user_id].unwrap.type.primitive).to be(Integer)
      end
    end

    xcontext 'for complex table' do
      before do |example|
        ctx = self

        conn.create_table :test_inferrence do
          primary_key :id
          String :text, text: false, null: false
          Time :time
          Date :date

          if ctx.oracle?(example)
            Date :datetime, null: false
          else
            DateTime :datetime, null: false
          end

          if ctx.sqlite?(example)
            add_constraint(:test_constraint) { char_length(text) > 3 }
          end

          if ctx.postgres?(example)
            Bytea :data
          else
            Blob :data
          end
        end
      end

      let(:dataset) { :test_inferrence }
      let(:source) { ROM::Relation::Name[dataset] }

      it 'can infer attributes for dataset' do |ex|
        date_primitive = oracle?(ex) ? Time : Date

        expect(schema[:id].source).to eql(source)
        expect(schema[:id].type.primitive).to be(Integer)

        expect(schema[:text].source).to eql(source)
        expect(schema[:text].type.primitive).to be(String)
        expect(schema[:text].meta[:limit]).to be(255)

        expect(schema[:time].source).to eql(source)
        expect(schema[:time].unwrap.type.primitive).to be(Time)

        expect(schema[:date].source).to eql(source)
        expect(schema[:date].unwrap.type.primitive).to be(date_primitive)

        expect(schema[:datetime].source).to eql(source)
        expect(schema[:datetime].type.primitive).to be(Time)

        expect(schema[:data].source).to eql(source)
        expect(schema[:data].unwrap.type.primitive).to be(Sequel::SQL::Blob)
      end
    end

    xcontext 'character datatypes' do
      before do
        conn.create_table :test_characters do
          String :text1, text: false, null: false
          String :text2, size: 100, null: false
          column :text3, 'char(100)', null: false
          column :text4, 'varchar', null: false
          column :text5, 'varchar(100)', null: false
          String :text6, size: 100
        end
      end

      let(:dataset) { :test_characters }
      let(:source) { ROM::Relation::Name[dataset] }

      let(:char_t) { ROM::SQL::Types::String.meta(source: source) }

      it 'infers attributes with limit' do
        expect(schema[:text1].source).to eql(source)
        expect(schema[:text1].meta[:limit]).to be(255)
        expect(schema[:text1].unwrap.type.primitive).to be(String)

        expect(schema[:text2].source).to eql(source)
        expect(schema[:text2].meta[:limit]).to be(100)
        expect(schema[:text2].unwrap.type.primitive).to be(String)

        expect(schema[:text3].source).to eql(source)
        expect(schema[:text3].meta[:limit]).to be(100)
        expect(schema[:text3].unwrap.type.primitive).to be(String)

        expect(schema[:text4].source).to eql(source)
        expect(schema[:text4].meta[:limit]).to be(255)
        expect(schema[:text4].unwrap.type.primitive).to be(String)

        expect(schema[:text5].source).to eql(source)
        expect(schema[:text5].meta[:limit]).to be(100)
        expect(schema[:text5].unwrap.type.primitive).to be(String)

        expect(schema[:text6].source).to eql(source)
        # TODO: is this supposed to store the limit?
        # expect(schema[:text6].meta[:limit]).to be(100)
        expect(schema[:text6].unwrap.type.primitive).to be(String)
      end
    end

    xcontext 'numeric datatypes' do
      before do
        conn.create_table :test_numeric do
          primary_key :id
          decimal :dec, null: false
          decimal :dec_prec, size: 12, null: false
          numeric :num, size: [5, 2], null: false
          smallint :small
          integer :int
          float :floating
          double :double_p
        end
      end

      let(:dataset) { :test_numeric }
      let(:source) { ROM::Relation::Name[dataset] }

      let(:integer) { ROM::SQL::Types::Int.meta(source: source) }
      let(:decimal) { ROM::SQL::Types::Decimal.meta(source: source) }

      it 'infers attributes with precision' do |example|
        pending 'Add precision inferrence for Oracle' if oracle?(example)

        expect(schema[:id].source).to eql(source)
        expect(schema[:id].type.primitive).to be(Integer)

        expect(schema[:dec].source).to eql(source)
        expect(schema[:dec].type.primitive).to be(BigDecimal)
        # TODO: is this supposed to be stored here?
        # expect(schema[:dec].meta[:precision]).to be(10)
        # expect(schema[:dec].meta[:scale]).to be(0)

        expect(schema[:dec_prec].source).to eql(source)
        expect(schema[:dec_prec].type.primitive).to be(BigDecimal)
        expect(schema[:dec_prec].meta[:precision]).to be(12)
        expect(schema[:dec_prec].meta[:scale]).to be(0)

        expect(schema[:small].source).to eql(source)
        expect(schema[:small].unwrap.type.primitive).to be(Integer)

        expect(schema[:int].source).to eql(source)
        expect(schema[:int].unwrap.type.primitive).to be(Integer)

        expect(schema[:floating].source).to eql(source)
        expect(schema[:floating].unwrap.type.primitive).to be(Float)

        expect(schema[:double_p].source).to eql(source)
        expect(schema[:double_p].unwrap.type.primitive).to be(Float)
      end
    end
  end

  xdescribe 'using commands with inferred schema' do
    before do
      inferrable_relations.concat %i[people]
    end

    let(:relation) { container.relations[:people] }

    before do
      conf.relation(:people) do
        schema(infer: true)
      end

      conf.commands(:people) do
        define(:create) do
          result :one
        end
      end
    end

    describe 'inserting' do
      let(:create) { commands[:people].create }

      context "Sequel's types" do
        before do
          conn.create_table :people do
            primary_key :id
            String :name, null: false
          end
        end

        it "doesn't coerce or check types on insert by default" do
          result = create.(name: Sequel.function(:upper, 'Jade'))

          expect(result).to eql(id: 1, name: 'JADE')
        end
      end

      context 'nullable columns' do
        before do
          conn.create_table :people do
            primary_key :id
            String :name, null: false
            Integer :age, null: true
          end
        end

        it 'allows to insert records with nil value' do
          result = create.(name: 'Jade', age: nil)

          expect(result).to eql(id: 1, name: 'Jade', age: nil)
        end

        it 'allows to omit nullable columns' do
          result = create.(name: 'Jade')

          expect(result).to eql(id: 1, name: 'Jade', age: nil)
        end
      end

      context 'columns with default value' do
        before do
          conn.create_table :people do
            primary_key :id
            String :name, null: false
            Integer :age, null: false, default: 18
          end
        end

        it 'sets default value on missing key' do
          result = create.(name: 'Jade')

          expect(result).to eql(id: 1, name: 'Jade', age: 18)
        end

        it 'raises an error on inserting nil value' do
          expect { create.(name: 'Jade', age: nil) }.to raise_error(ROM::SQL::NotNullConstraintError)
        end
      end

      context 'coercions' do
        context 'date' do
          before do
            conn.create_table :people do
              primary_key :id
              String :name, null: false
              Date :birth_date, null: false
            end
          end

          it 'accetps Time' do |ex|
            time = Time.iso8601('1970-01-01T06:00:00')
            result = create.(name: 'Jade', birth_date: time)
            # Oracle's Date type stores time
            expected_date = oracle?(ex) ? time : Date.iso8601('1970-01-01T00:00:00')

            expect(result).to eql(id: 1, name: 'Jade', birth_date: expected_date)
          end
        end

        unless metadata[:sqlite] && defined? JRUBY_VERSION
          context 'timestamp' do
            before do |ex|
              ctx = self

              conn.create_table :people do
                primary_key :id
                String :name, null: false
                # TODO: fix ROM, then Sequel to infer TIMESTAMP NOT NULL for Oracle
                Timestamp :created_at, null: ctx.oracle?(ex)
              end
            end

            it 'accepts Date' do
              date = Date.today
              result = create.(name: 'Jade', created_at: date)

              expect(result).to eql(id: 1, name: 'Jade', created_at: date.to_time)
            end

            it 'accepts Time' do |ex|
              now = Time.now
              result = create.(name: 'Jade', created_at: now)

              expected_time = trunc_ts(now, drop_usec: mysql?(ex))
              expect(result).to eql(id: 1, name: 'Jade', created_at: expected_time)
            end

            it 'accepts DateTime' do |ex|
              now = DateTime.now
              result = create.(name: 'Jade', created_at: now)

              expected_time = trunc_ts(now, drop_usec: mysql?(ex))
              expect(result).to eql(id: 1, name: 'Jade', created_at: expected_time)
            end

            # TODO: Find out if Oracle's adapter really doesn't support RFCs
            if !metadata[:mysql] && !metadata[:oracle]
              it 'accepts strings in RFC 2822' do
                now = Time.now
                result = create.(name: 'Jade', created_at: now.rfc822)

                expect(result).to eql(id: 1, name: 'Jade', created_at: trunc_ts(now, drop_usec: true))
              end

              it 'accepts strings in RFC 3339' do
                now = DateTime.now
                result = create.(name: 'Jade', created_at: now.rfc3339)

                expect(result).to eql(id: 1, name: 'Jade', created_at: trunc_ts(now, drop_usec: true))
              end
            end
          end
        end
      end
    end
  end
end
