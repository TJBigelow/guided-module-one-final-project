class CocktailPage
    def initialize(cocktail)
        system 'clear'
        puts"Cocktail Name: #{cocktail.name}"
        puts "---"
        puts "Cocktail Ingredients:"
        cocktail.ingredients.each do |i|
            # binding.pry
            ci = CocktailIngredient.all.find{|ci| ci.ingredient_id == i.id && ci.cocktail_id == cocktail.id}
            puts "#{i.name} - #{ci.measure}"
        end
        puts "---\nCocktail Instructions:"
        puts cocktail.instructions
        puts "---\nCocktail Glass:"
        puts cocktail.glass
    end
end