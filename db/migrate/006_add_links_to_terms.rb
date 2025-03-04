# frozen_string_literal: true

class AddLinksToTerms < ActiveRecord::Migration[7.0]
  def change
    add_column :terms, :links, :text, default: '[]', null: false
  end
end
