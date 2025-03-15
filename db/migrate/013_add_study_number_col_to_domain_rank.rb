# frozen_string_literal: true

class AddStudyNumberColToDomainRank < ActiveRecord::Migration[7.0]
  def change
    add_column :domain_ranks, :study_number, :integer, default: 0, null: false
  end
end
