# frozen_string_literal: true

require 'yaml'
require 'rom/files/types'
require_relative '../markup/attributes_inferrer'

module ROM
  module Files
    module Types
      YAML = (Files::Types::Hash | Files::Types::Array).constructor do |value|
        if value.respond_to?(:to_hash)
          value.to_hash
        elsif value.respond_to?(:to_ary)
          value.to_ary
        else
          ::YAML.safe_load(value)
        end
      end
    end

    module Extensions
      module Yaml
        class AttributesInferrer < Markup::AttributesInferrer
          def markup_type
            Types::YAML
          end
        end
      end
    end

    Schema::AttributesInferrer.register 'text/markdown', Extensions::Yaml::AttributesInferrer.new.freeze
  end
end
