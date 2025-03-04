# frozen_string_literal: true

class Term < ActiveRecord::Base
  self.primary_key = :id
  belongs_to :category, foreign_key: 'category_id'
  # serialize :synonyms, JSON
end
