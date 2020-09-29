class Cocktail < ActiveRecord::Base
    has_many :cocktail_ingredients
    has_many :ingredients, through: :cocktail_ingredients
end