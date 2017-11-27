# frozen_string_literal: true

require 'pathname'
require 'dry/core/extensions'

class Pathname
  extend Dry::Core::Extensions

  register_extension :constants do
    require_relative 'extensions/constants'
  end

  register_extension :explode do
    require_relative 'extensions/explode'
    include Extensions::Explode
  end

  register_extension :ext do
    require_relative 'extensions/ext'
    include Extensions::Ext
  end

  register_extension :partial do
    require_relative 'extensions/partial'
    include Extensions::Partial
  end

  register_extension :pathmap do
    require_relative 'extensions/pathmap'
    include Extensions::Pathmap
  end
end
