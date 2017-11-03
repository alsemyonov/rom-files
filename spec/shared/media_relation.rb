# frozen_string_literal: true

require 'shared/media_files'

RSpec.shared_context 'media relation' do
  include_context 'media files'

  before :each do
    configuration.relation(:media) do
      dataset { sort }

      # @return [ROM::Files::Relation]
      def text_files
        select('*.txt')
      end
    end
  end
end
