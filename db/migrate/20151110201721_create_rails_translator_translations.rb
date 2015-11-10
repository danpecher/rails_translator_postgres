class CreateRailsTranslatorTranslations < ActiveRecord::Migration
  def change
    create_table :rails_translator_translations do |t|
      t.string :key,value

      t.timestamps null: false
    end
  end
end
