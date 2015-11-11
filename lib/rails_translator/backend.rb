module RailsTranslator
  module Backend
    class Static
      def initialize(*args)
        #add(*args) unless args.empty?
      end

      def translate(locale, key, options = {})
        # return super if options[:fallback]
        # default = extract_non_symbol_default!(options) if options[:default]

        # options[:fallback] = true
        # I18n.fallbacks[locale].each do |fallback|
        #   catch(:exception) do
        #     result = super(fallback, key, options)
        #     return result unless result.nil?
        #   end
        # end
        # options.delete(:fallback)

        # return super(locale, nil, options.merge(:default => default)) if default
        result = Rails.cache.fetch("rails_translator.#{key}.#{locale}")

        if result.nil?
          throw(:exception, I18n::MissingTranslation.new(locale, key, options))
        end

        if result == ''
          return key
        end

        options.each { |k, v| result.gsub!(/%\{.*\}/, v) if v.is_a? String }

        return result
      end

      def extract_non_symbol_default!(options)
        # defaults = [options[:default]].flatten
        # first_non_symbol_default = defaults.detect{|default| !default.is_a?(Symbol)}
        # if first_non_symbol_default
        #   options[:default] = defaults[0, defaults.index(first_non_symbol_default)]
        # end
        # return first_non_symbol_default
      end

      def reload!
        keys = []
        Dir.glob(Rails.root.join('./**/*.erb')).each do |file|
          open(file) do |f|
            f.each_line.select do |line|
              matches = /t\(\'(.*)\'\)/.match(line)
              if matches.nil? || matches[1].nil?
                next
              end
              keys.push matches[1]
            end
          end
        end

        keys.uniq!

        to_create = []

        translations = Translation.all.to_a

        translations.each do |item|
          keys.reject! { |v| v == item.key }
        end

        keys.each do |key|
          translations.push(Translation.create(key: key))
        end
        translations.each do |item|
          item.values.each do |locale, translation|
            Rails.cache.write("rails_translator.#{item[:key]}.#{locale}", translation)
          end
        end
      end

      protected

      # alias :orig_interpolate :interpolate unless method_defined? :orig_interpolate
      def interpolate(locale, string, values = {})
        # result = orig_interpolate(locale, string, values)
        # translation = translation(string)
        # translation.nil? ? result : translation.replace(result)
      end


      def translation(result, meta = nil)
        # return unless result

        # case result
        # when Numeric
        #   result
        # when String
        #   result = Translation::Static.new(result) unless result.is_a? Translation::Static
        #   result.set_meta meta
        #   result
        # when Hash
        #   begin
        #     ary = result.map do |key, value|
        #       [key, translation(value, meta)]
        #     end
        #     Hash[*ary.flatten]
        #   rescue ArgumentError
        #     Hash[*ary]
        #   end
        # when Array
        #   result.map do |value|
        #     translation(value, meta)
        #   end
        # else
        #   result
        # end
      end
    end
  end
end