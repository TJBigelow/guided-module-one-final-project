class Ingredient < ActiveRecord::Base
    has_many :cocktails, through: :cocktail_ingredients
end