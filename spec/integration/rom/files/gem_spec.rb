#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rom-files'
require 'rspec'

RSpec.example_group ROM::Files, 'usage with gem' do
  # @param [ROM::ConfigurationDSL] config
  def def_tools(config)
    config.relation :tools do
      dataset do
        select('*') # .stat(executable: true)
      end

      schema 'bin' do
        # use :shebang
      end
    end
  end

  # @param [ROM::ConfigurationDSL] config
  def def_examples(config)
    config.relation :examples do
      dataset { select '**/*.rb' }

      schema 'examples' do
        # use :ruby
      end
    end
  end

  def def_docs(config)
    config.relation :docs do
      dataset { select '**/*.md' }

      schema 'text/markdown' do
        # use :content, type: Types::Markdown
      end
    end
  end

  def def_library(config)
    config.relation :implementations do
      dataset { inside('lib').recursively }

      schema 'lib' do
        # associations do
        #   has_one :specification
        # end
      end
    end
  end

  def def_specification(config)
    config.relation :specifications do
      dataset { select '**/*_spec.rb' }

      schema 'spec' do
        # associations do
        #   belongs_to :implementation
        # end
      end
    end
  end

  # @return [ROM::Container]
  subject(:container) do
    ROM.container(:files, uri) do |config|
      def_docs(config)
      def_tools(config)
      def_examples(config)
      def_library(config)
      def_specification(config)
      config.relation :gem do
        schema :gem do
          # associations do
          #   has_many :implementations
          #   has_many :specifications
          #   has_many :rake_files
          # end
        end
      end
    end
  end
  let(:uri) { SPEC_ROOT.dirname }
  let(:library_files) { container.relations[:implementations] }

  xexample 'Container usage' do
    require 'pry'
    binding.pry # rubocop:disable Lint/Debugger
  end

  example 'List library files' do
    expect(library_files.to_a).to be_a Array
  end
end

require 'rspec/autorun' if $PROGRAM_NAME == __FILE__
