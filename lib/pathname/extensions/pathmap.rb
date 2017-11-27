# frozen_string_literal: true

require 'pathname/extensions'

class Pathname
  module Extensions
    module Pathmap
      def self.included(host)
        host.load_extensions :ext, :explode, :partial
        super
      end

      # Map the path according to the given specification. The specification
      # controls the details of the mapping. The following special patterns are
      # recognized:
      #
      # * `%p` - The complete path.
      # * `%f` - The base file name of the path, with its file extension,
      #                but without any directories.
      # * `%n` - The file name of the path without its file extension.
      # * `%d` - The directory list of the path.
      # * `%x` - The file extension of the path.  An empty string if there
      #                is no extension.
      # * `%X` - Everything *but* the file extension.
      # * `%s` - The alternate file separator if defined, otherwise use #
      #                the standard file separator.
      # * `%%` - A percent sign.
      #
      # @note
      #   The `%d` specifier can also have a numeric prefix (e.g. `%2d`).
      #
      #   If the number is positive, only return (up to) `n` directories in the
      #   path, starting from the left hand side.
      #
      #   If `n` is negative, return (up to) `n` directories from the
      #   right hand side of the path.
      #
      # @example
      #   'a/b/c/d/file.txt'.pathmap("%2d")   => 'a/b'
      #   'a/b/c/d/file.txt'.pathmap("%-2d")  => 'c/d'
      #
      # Also the `%d`, `%p`, `%f`, `%n`,
      # `%x`, and `%X` operators can take a pattern/replacement
      # argument to perform simple string substitutions on a particular part of
      # the path.  The pattern and replacement are separated by a comma and are
      # enclosed by curly braces.  The replacement spec comes after the %
      # character but before the operator letter.  (e.g. `%{old,new}d`).
      # Multiple replacement specs should be separated by semi-colons (e.g.
      # `%{old,new;src,bin}d`).
      #
      # Regular expressions may be used for the pattern, and back refs may be
      # used in the replacement text.  Curly braces, commas and semi-colons are
      # excluded from both the pattern and replacement text (let's keep parsing
      # reasonable).
      #
      # @example
      #   "src/org/onestepback/proj/A.java".pathmap("%{^src,class}X.class")
      #   #=> "class/org/onestepback/proj/A.class"
      #
      #
      # @example If the replacement text is '*', then a block may be provided to perform some arbitrary calculation for the replacement.
      #   "/path/to/file.TXT".pathmap("%X%{.*,*}x") { |ext|
      #      ext.downcase
      #   } #=> "/path/to/file.txt"
      def pathmap(spec = nil, &block)
        return self if spec.nil?
        result = +''
        # noinspection SpellCheckingInspection
        spec.scan(/%\{[^}]*\}-?\d*[sdpfnxX%]|%-?\d+d|%.|[^%]+/) do |frag|
          # noinspection SpellCheckingInspection
          case frag
          when '%f'
            result << basename.to_s
          when '%n'
            result << basename.ext.to_s
          when '%d'
            result << dirname.to_s
          when '%x'
            result << extname.to_s
          when '%X'
            result << ext.to_s
          when '%p'
            result << to_s
          when '%s'
            result << (File::ALT_SEPARATOR || File::SEPARATOR)
          when '%-'
            result
          when '%%'
            result << '%'
          when /%(-?\d+)d/
            result << partial(Regexp.last_match(1).to_i).to_s
          when /^%{([^}]*)}(\d*[dpfnxX])/
            patterns = Regexp.last_match(1)
            operator = Regexp.last_match(2)
            result << pathmap('%' + operator).pathmap_replace(patterns, &block).to_s
          when /^%/
            raise ArgumentError, "Unknown pathmap specifier #{frag} in '#{spec}'"
          else
            result << frag
          end
        end
        Pathname(result)
      end

      # Perform the pathmap replacement operations on the given path. The
      # patterns take the form 'pat1,rep1;pat2,rep2...'.
      #
      # @param patterns [String]
      # @param block [Proc]
      # @return [Pathname]
      def pathmap_replace(patterns, &block)
        result = self
        patterns.split(';').each do |pair|
          pattern, replacement = pair.split(',')
          pattern = Regexp.new(pattern)
          result = if replacement == '*' && block_given?
                     result.sub(pattern, &block)
                   elsif replacement
                     result.sub(pattern, replacement)
                   else
                     result.sub(pattern, '')
                   end
        end
        result
      end
    end
  end
end
