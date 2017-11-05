# frozen_string_literal: true

require 'shared/media_files'

RSpec.shared_context 'media relation' do
  include_context 'media files'

  let(:relation) { container.relations[:media] }

  before :each do
    configuration.relation(:media) do
      # @return [ROM::Files::Relation]
      def text_files
        select('*.{txt,md}')
      end

      # @return [ROM::Files::Relation]
      def binary_files
        reject('*.txt', '*.md')
      end
    end
  end
end
