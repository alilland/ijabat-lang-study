# frozen_string_literal: true

class AddSynonymsToTerms < ActiveRecord::Migration[7.0]
  def change
    add_column :terms, :synonyms, :text, default: '[]', null: false
  end
end
