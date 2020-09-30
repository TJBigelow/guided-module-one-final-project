class Cocktail < ActiveRecord::Base
    has_many :cocktail_ingredients
    has_many :ingredients, through: :cocktail_ingredients

    def cocktail_page
        system 'clear'
        puts"Cocktail Name: #{self.name}"
        puts "---"
        puts "Cocktail Ingredients:"
        self.ingredients.each do |i|
            # binding.pry
            ci = CocktailIngredient.all.find{|ci| ci.ingredient_id == i.id && ci.cocktail_id == self.id}
            puts "#{i.name} - #{ci.measure}"
        end
        puts "---\nCocktail Instructions:"
        puts self.instructions
        puts "---\nCocktail Glass:"
        puts self.glass
    end
end