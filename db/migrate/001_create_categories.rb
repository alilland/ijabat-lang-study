# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: false do |t|
      t.string :id, primary_key: true, default: -> { 'lower(hex(randomblob(16)))' }
      t.string :category, null: false
      t.timestamps
    end
  end
end
