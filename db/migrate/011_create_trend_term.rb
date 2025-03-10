# frozen_string_literal: true

class CreateTrendTerm < ActiveRecord::Migration[7.0]
  def change
    create_table :trend_terms, id: false do |t|
      t.string :id, primary_key: true, default: -> { 'lower(hex(randomblob(16)))' }
      t.string :lang, null: false, default: ''
      t.string :source_term, null: false, default: ''
      t.string :normalized_term, null: false, default: ''
      t.timestamps
    end
  end
end
