# frozen_string_literal: true

class Category < ActiveRecord::Base
  self.primary_key = :id
  has_many :terms, foreign_key: 'category_id', dependent: :destroy
end
