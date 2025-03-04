# frozen_string_literal: true

class Language < ActiveRecord::Base
  self.primary_key = :lang  # Assuming `lang` is the primary key in `languages`
  has_many :terms, foreign_key: 'language', primary_key: 'lang'
end
