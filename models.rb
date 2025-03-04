require 'active_record'

class Category < ActiveRecord::Base
  self.primary_key = :id
  has_many :terms, foreign_key: 'category_id', dependent: :destroy
end

class Term < ActiveRecord::Base
  belongs_to :category, foreign_key: 'category_id'
end
