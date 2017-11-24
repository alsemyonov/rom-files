# frozen_string_literal: true

old_verbose = $VERBOSE
$VERBOSE = nil
require 'parser/current'
$VERBOSE = old_verbose
require 'rom/files/types'

module ROM
  module Files
    module Types
      module Ruby
        ASTNode = Parser::AST::Node

        AST = ROM::Types.Constructor(ASTNode) do |doc|
          case doc
          when ASTNode
            doc
          when String
            Parser::CurrentRuby.parse(doc)
          when Pathname
            Parser::CurrentRuby.parse(doc.read)
          else
            raise ArgumentError, "Cannot convert #{doc.inspect} to Ruby AST"
          end
        end

        Comments = Types::Array.of(Parser::Source::Comment)

        ASTWithComments = ROM::Types.Constructor(Array) do |doc|
          case doc
          when Array
            doc
          when String
            Parser::CurrentRuby.parse_with_comments(doc)
          when Pathname
            Parser::CurrentRuby.parse_file_with_comments(doc.to_s)
          else
            raise ArgumentError, "Cannot convert #{doc.inspect} to Ruby AST"
          end
        end
      end
    end
  end
end
