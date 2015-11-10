module RailsTranslator
  class IndexController < ApplicationController
    def index
      @locale = params[:locale].nil? ? I18n.default_locale : params[:locale]
      @translations = Translation.any_of({"key": /.*#{params[:query]}.*/}, {"values.#{@locale}": /.*#{params[:query]}.*/}).paginate(per_page: 40, page: params[:page])
    end

    def update
      params[:translations].each do |k, trans|
        t = Translation.find_by(key: k)
        prev = t.values

        trans.each do |locale, value|
          prev[locale] = value
        end

        t.update_attributes(values: prev)
      end

      I18n.backend.reload!

      redirect_to :back
    end
  end
end
