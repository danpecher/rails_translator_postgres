module RailsTranslator
  module Backend
    class Static
      def translate(locale, key, options = {})
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
          translations.push(Translation.create(key: key, locale: I18n.default_locale))
        end
        translations.each do |item|
          Rails.cache.write("rails_translator.#{item.key}.#{item.locale}", item.value)
        end
      end
    end
  end
end
