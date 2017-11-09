# frozen_string_literal: true

require 'rom/files/schema'
require 'shared/media_relation'

RSpec.describe ROM::Files::Schema do
  describe '#primary_key' do
    subject(:primary_key) { schema.primary_key }
    let(:schema) { schema_proc.call }

    before { schema.finalize_attributes!.finalize! }

    context 'with primary key defined' do
      let(:schema_proc) do
        Class.new(ROM::Relation[:files]).schema do
          attribute :__FILE__, ROM::Files::Types::Path
        end
      end

      it { is_expected.to eql [schema[:__FILE__]] }
    end

    context 'without primary key defined' do
      let(:schema_proc) do
        Class.new(ROM::Relation[:files]).schema do
          attribute :__FILE__, ROM::Files::Types::Pathname
        end
      end

      it { is_expected.to eql [] }
    end
  end
end
