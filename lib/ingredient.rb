class Ingredient < ActiveRecord::Base
    has_many :cocktail_ingredients
    has_many :cocktails, through: :cocktail_ingredients

    def ingredient_page
        system 'clear'
        puts "Ingredient Name: #{self.name}\n---\nIngredient Description:\n#{self.description}"
    end
end