# frozen_string_literal: true

require 'shared/filesystem_setup'

RSpec.shared_context 'gateway setup' do
  include_context 'filesystem setup'

  let(:configuration) { ROM::Configuration.new(:files, uri) }
  let(:container) { ROM.container(configuration) }

  # @param [Pathname, #to_s] path
  # @return [Pathname]
  def P(path) # rubocop:disable Naming/MethodName
    Pathname(path)
  end
end
