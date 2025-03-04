# frozen_string_literal: true

class CreateTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :terms, id: false do |t|
      t.string :id, primary_key: true, default: -> { 'lower(hex(randomblob(16)))' }
      t.string :category_id, null: false
      t.string :term, null: false
      t.string :language, null: false
      t.string :search_term, null: false
      t.foreign_key :categories, column: :category_id, primary_key: :id, on_delete: :cascade
      t.timestamps
    end
  end
end
