# frozen_string_literal: true

class AddHasCultsToTerms < ActiveRecord::Migration[7.0]
  def change
    add_column :terms, :has_cults, :boolean, default: false, null: false
  end
end
