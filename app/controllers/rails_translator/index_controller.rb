module RailsTranslator
  class IndexController < ApplicationController
    before_action :set_locale
    def index
      @translations = Translation.where("locale = :locale", locale: @locale)
      @translations = @translations.where("key ILIKE :search", search: "%#{params[:query]}%") unless params[:query].nil? || params[:query].empty?
      @translations = @translations.order(:id).paginate(per_page: 40, page: params[:page])
    end

    def update
      params[:translations].each do |k, trans|
        Translation.where("key = :key and locale = :locale", key: k, locale: @locale).update_all(:value => trans)
      end

      I18n.backend.reload!

      redirect_to :back
    end

    private
    def set_locale
      @locale = params[:locale].nil? ? I18n.default_locale : params[:locale]
    end
  end
end
