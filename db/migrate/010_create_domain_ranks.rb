# frozen_string_literal: true

class CreateDomainRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_ranks, id: false do |t|
      t.string :id, primary_key: true, default: -> { 'lower(hex(randomblob(16)))' }
      t.string :domain, null: false
      t.integer :count, null: false
      t.timestamps
    end
  end
end
