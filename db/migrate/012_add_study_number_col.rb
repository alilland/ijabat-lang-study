# frozen_string_literal: true

class AddStudyNumberCol < ActiveRecord::Migration[7.0]
  def change
    add_column :terms, :study_number, :integer, default: 0, null: false
  end
end
