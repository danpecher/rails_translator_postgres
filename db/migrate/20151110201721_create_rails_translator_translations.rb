class CreateRailsTranslatorTranslations < ActiveRecord::Migration
  def change
    create_table :rails_translator_translations do |t|
      t.string :key
      t.string :value
      t.string :locale
    end
  end
end
