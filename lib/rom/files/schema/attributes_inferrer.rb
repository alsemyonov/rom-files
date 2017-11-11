# frozen_string_literal: true

require 'dry/core/class_attributes'
require 'rom/files/constants'
require 'rom/files/attribute'
require 'mime/types/full'

module ROM
  module Files
    class Schema < ROM::Schema
      # @api private
      class AttributesInferrer
        extend Dry::Core::ClassAttributes
        extend Initializer

        KNOWN_COLUMNS = [ID].freeze

        # @!method self.registry
        #   @return [Hash{String => AttributesInferrer}]
        defines :registry, :attr_class
        registry Hash.new(new.freeze)
        attr_class Files::Attribute

        # @param type [String]
        # @param builder [TypeBuilder]
        # @return [AttributesInferrer]
        def self.register(type, builder)
          registry[type] = builder
        end

        def self.registered?(type)
          registry.key?(type)
        end

        # @param mime_type [String]
        # @return [AttributesInferrer]
        def self.[](mime_type)
          registry[mime_type]
        end

        # @!attribute [r] attr_class
        #   @return [Class(Files::Attribute)]
        option :attr_class, default: -> { self.class.attr_class }

        # @param schema [ROM::Files::Schema]
        # @param gateway [ROM::Files::Gateway]
        #
        # @api private
        def call(schema, gateway)
          inferred = infer_attributes(schema, gateway)

          missing = columns - inferred.map { |attr| attr.meta[:name] }

          [inferred, missing]
        end

        undef :with

        # @return [Files::Attribute]
        def build(type, name, schema)
          attr_class.new(type.meta(name: name, source: schema.name))
        end

        # @return [Array<Symbol>]
        def columns
          KNOWN_COLUMNS
        end

        def with(new_options)
          self.class.new(options.merge(new_options))
        end

        def infer_attributes(schema, _gateway)
          [build(Types::Path, ID, schema)]
        end
      end
    end
  end
end
