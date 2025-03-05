# frozen_string_literal: true

class AddQualityLinksBoolToTerms < ActiveRecord::Migration[7.0]
  def change
    add_column :terms, :score, :integer, default: 0, null: false
    add_column :terms, :difficulty, :text, default: '', null: false
  end
end
