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

      # @!method select(*patterns)
      #   @param (see Dataset#select)
      #   @return (see Dataset#select)
      # @!method reject(*patterns)
      #   @param (see Dataset#reject)
      #   @return (see Dataset#reject)
      # @!method sort(sort_by = :to_s)
      #   @param (see Dataset#sort)
      #   @return (see Dataset#sort)
      forward :select, :reject, :sort, :inside, :recursive
    end
  end
end
