class Cocktail < ActiveRecord::Base
    has_many :ingredients, through: :cocktail_ingredients
end