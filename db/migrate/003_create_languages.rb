# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :languages, id: false do |t|
      t.string :id, primary_key: true, default: -> { 'lower(hex(randomblob(16)))' }
      t.string :lang, null: false
      t.string :hl, null: false
      t.string :lr, null: false
      t.timestamps
    end
  end
end
