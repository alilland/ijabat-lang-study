require 'active_record'

class CreateTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :terms do |t|
      t.string :category_id, null: false
      t.string :term, null: false
      t.string :language, null: false
      t.string :search_term, null: false
      t.foreign_key :categories, column: :category_id, primary_key: :id, on_delete: :cascade
      t.timestamps
    end
  end
end
