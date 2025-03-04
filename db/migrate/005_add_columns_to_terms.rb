# frozen_string_literal: true

class AddColumnsToTerms < ActiveRecord::Migration[7.0]
  def change
    add_column :terms, :total_results, :integer, default: 0, null: false
  end
end
