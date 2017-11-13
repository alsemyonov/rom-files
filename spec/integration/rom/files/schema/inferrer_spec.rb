# frozen_string_literal: true

require 'rom/files/schema/inferrer'
require 'shared/rom/files/media_files'

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

    context 'for any file set' do
      let(:dataset) { :media }

      describe '__FILE__' do
        subject(:attribute) { schema[:__FILE__] }

        its(:source) { is_expected.to eql source }
        its('type.primitive') { is_expected.to be Pathname }
      end
    end

    context 'for `text/plain` file set' do
      let(:relation_name) { :texts }
      let(:dataset) { 'text/plain' }

      describe '__FILE__' do
        subject(:attribute) { schema[:__FILE__] }

        its(:source) { is_expected.to eql source }
        its('type.primitive') { is_expected.to be Pathname }
      end

      describe 'DATA' do
        subject(:attribute) { schema[:DATA] }

        its(:source) { is_expected.to eql source }
        its('type.primitive') { is_expected.to be String }

        it 'autoloads contents' do
          expect(attribute.meta[:DATA]).to be(true)
        end
      end
    end
  end
end
