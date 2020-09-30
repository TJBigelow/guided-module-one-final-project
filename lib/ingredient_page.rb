class IngredientPage
    def initialize(ingredient)
        system 'clear'
        puts "Ingredient Name: #{ingredient.name}\n---\nIngredient Description:\n#{ingredient.description}"
    end
end