# frozen_string_literal: true

require 'rom/files/types'

module ROM
  module Files
    module Plugins
      module Schema
        # A plugin for automatically adding stat properties of file
        # to the schema definition
        #
        # @example Generic `__stat__` field with String type
        #   schema do
        #     use :stat
        #   end
        #
        # @example Specify set of properties
        #   schema do
        #     use :stat, properties: %i[atime birthtime ctime]
        #   end
        #
        # @api public
        module Stat
          NAME = :stat

          TYPES = {
            atime: Types::Time,
            basename: Types::String,
            birthtime: Types::Time,
            blksize: Types::Int.optional,
            blocks: Types::Int.optional,
            ctime: Types::Time,
            dev: Types::Int,
            dev_major: Types::Int,
            dev_minor: Types::Int,
            ftype: Types::FileType,
            gid: Types::Int,
            ino: Types::Int,
            mode: Types::Int,
            mtime: Types::Time,
            nlink: Types::Int,
            rdev: Types::Int,
            rdev_major: Types::Int,
            rdev_minor: Types::Int,
            size: Types::Int,
            uid: Types::Int
          }.freeze

          ALIASES = {
            accessed_at: :atime,
            changed_at: :ctime,
            updated_at: :mtime,
            created_at: :birthtime,
            type: :ftype
          }.freeze

          class << self
            # @api private
            def apply(schema, name: NAME, stats: EMPTY_ARRAY, aliases: EMPTY_HASH)
              attributes = []
              attributes = [build_property(schema, name, type: Types::FileStat)] if name
              attributes += stats.map { |stat| build_property(schema, stat) }
              attributes += aliases.map do |as, stat|
                build_property(schema, as, stat: stat)
              end

              schema.attributes.concat(
                schema.class.attributes(attributes, schema.attr_class)
              )
            end

            private

            def build_property(schema, name, stat: ALIASES[name] || name, type: TYPES[stat])
              raise ArgumentError, "Unknown property #{(stat || name).inspect}" unless type
              type.meta(name: name, source: schema.name, __stat__: (stat == NAME) || stat)
            end
          end

          # @api private
          module DSL
            # @example Sets non-default list of stat properties
            #   schema do
            #     use :stat
            #     stat :basename
            #   end
            #
            # @example Sets list of aliased properties
            #   schema do
            #     use :stat
            #     stat aliased: { created_at: :ctime }
            #   end
            #
            # @api public
            def stat(name = NAME, stats: EMPTY_ARRAY, aliases: EMPTY_HASH)
              options = plugin_options(:stat)
              options[:name] = name
              options[:stats] = stats
              options[:aliases] = aliases

              self
            end
          end
        end
      end
    end
  end
end
