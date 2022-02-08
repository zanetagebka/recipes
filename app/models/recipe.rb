class Recipe < ApplicationRecord
  scope :search_ingredients, ->(param) { where("array_to_string(ingredients, '') ILIKE ANY ( array[?] )", param) }
end
