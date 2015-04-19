require "plist"
require "serverkit/resources/base"
require "shellwords"
require "tempfile"

module Serverkit
  module Resources
    # A resource class for Mac OS X user defaults system.
    class Defaults < Base
      DEFAULT_DOMAIN = "NSGlobalDomain"

      # @example "com.apple.TextEdit"
      attribute :domain, default: DEFAULT_DOMAIN, type: String

      # @example "com.apple.keyboard.fnState"
      attribute :key, required: true, type: String

      # @example 1
      attribute :value, required: true, type: [Array, Fixnum, Float, Hash, String]

      def apply
        run_command("defaults write #{escaped_domain} #{escaped_key} #{type_option} #{value_in_plist}")
      end

      # @note Override
      # @return [true, false]
      def check
        value == read_value
      end

      private

      # @note Override
      def default_id
        "#{domain} #{key}"
      end

      # @return [String]
      # @example "com.apple.TextEdit"
      def escaped_domain
        ::Shellwords.shellescape(domain)
      end

      # @return [String]
      # @example "com.apple.keyboard.fnState"
      def escaped_key
        ::Shellwords.shellescape(key)
      end

      # @return [String]
      # @example "foo\\ bar"
      def escaped_value
        ::Shellwords.shellescape(value)
      end

      # @return [true, false] True if specified value is same with stored value
      def has_same_value?
        value == stored_value
      end

      # @return [String]
      # @example "42\n"
      def read_binary_value
        run_command("defaults read #{escaped_domain} #{escaped_key}").stdout
      end

      # @return [Object] Plain old ruby object with dirty-coerce
      def read_value
        case raw_value = read_raw_value
        when /\A-?\d+\z/
          raw_value.to_i
        when /\A-?\d+\.\d+\z/
          raw_value.to_f
        else
          raw_value
        end
      end

      # @return [Array, Hash, String, nil]
      # @example "1"
      def read_raw_value
        tempfile = ::Tempfile.new("")
        tempfile << read_binary_value
        tempfile.close
        run_command("plutil -convert xml1 #{tempfile.path}")
        ::Plist.parse_xml(tempfile.path)
      end

      # @return [String]
      def value_in_plist
        ::Shellwords.shellescape(Plist.generate(value))
      end

      # @return [String]
      def type_option
        case value
        when Fixnum
          "-int"
        when Float
          "-float"
        when String
          "-string"
        end
      end

      class Plist
        class << self
          # @param [Object] Plain old ruby object made from JSON or YAML
          # @return [String]
          def generate(object)
            case object
            when Array
              "(" + object.map { |element| generate(element) }.join(", ") + ")"
            when Hash
              "{" + object.map { |key, value| "#{generate(key)} = #{generate(value)}" }.join("; ") + "}"
            when false
              generate(0)
            when true
              generate(1)
            else
              object.inspect
            end
          end
        end
      end
    end
  end
end
