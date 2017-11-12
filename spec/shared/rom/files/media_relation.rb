# frozen_string_literal: true

require 'shared/rom/files/media_files'

RSpec.shared_context 'media relation' do
  include_context 'media files'

  subject(:relation) { container.relations.media }

  before :each do
    configuration.relation :media do
      schema :media, infer: true

      # @return [ROM::Files::Relation]
      def text_files
        select('*.{txt,md}')
      end

      # @return [ROM::Files::Relation]
      def binary_files
        reject('*.txt', '*.md')
      end
    end

    configuration.relation :text do
      schema 'text/plain', infer: true do
      end
    end
  end
end
