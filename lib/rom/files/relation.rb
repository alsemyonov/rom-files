# frozen_string_literal: true

require 'rom/relation'
require_relative 'schema'

module ROM
  module Files
    class Relation < ROM::Relation
      include Enumerable
      include Files

      adapter :files
      schema_class Files::Schema

      forward :select, :sort
    end
  end
end
