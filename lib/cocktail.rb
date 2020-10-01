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

    def cocktail_lookup
        system 'clear'
        puts "Which cocktail would you like to look up?"
        cocktail_input = gets.chomp
        lookup_array = Cocktail.all.map{|c| [c.id, c.name.downcase]}
        #binding.pry
        lookup_id = lookup_array.find{|c| c[1] == cocktail_input.downcase}
        if !lookup_id
            puts "That cocktail does not exist in our database. \nWould you like to add it? (y/n)"
            user_input = gets.chomp.downcase
            if ['y','yes'].any?(user_input)
                new_cocktail = add_cocktail(cocktail_input)
                lookup_id = new_cocktail.id
            else
                self.landing_page####needs to return to the building of the cabinet while retaining the cabinet from before
            end
            lookup_id = new_cocktail.id
        else
            lookup_id = lookup_id.first
        end
        lookup = Cocktail.all.find(lookup_id)
        lookup.cocktail_page
        self.return_to_landing
    end

    def add_cocktail(cocktail_input)
        ingredients = cocktail_ingredients
        puts "#{cocktail_input} ingredients: #{ingredients.map{|i| i.name}}"
        ingredient_measures = ingredients.map do |i|
            puts "What measurement of #{i.name}"
            gets.chomp
        end
        puts "How do you make #{cocktail_input}?"
        instructions = gets.chomp
        puts "What glass do you drink #{cocktail_input} from?"
        glass = gets.chomp
        new_cocktail = Cocktail.create(name: cocktail_input, instructions: instructions, glass: glass, category: 'User Submitted')
        ingredients.each do |i|
            new_cocktail.ingredients << i
            new_cocktail_ingredient = CocktailIngredient.all.find_by(cocktail_id: new_cocktail.id, ingredient_id: i.id)
            index = ingredients.index(i)
            new_cocktail_ingredient.measure = ingredient_measures[index]
            new_cocktail_ingredient.save
        end
        new_cocktail
    end

    def cocktail_ingredients(ing_arr=[])
        ingredients = ing_arr
        if !ingredients.empty?
            puts "Current ingredients: #{ingredients.map{|i| i.name}}"
            puts "add more ingredients or type 'end'"
            user_input = gets.chomp
            if user_input.downcase == 'end'
                return ingredients
            else
                ingredients << Ingredient.ingredient_search(user_input)
            end
        else
            puts "Add an ingredient"
            user_input = gets.chomp.downcase
            ingredients << Ingredient.ingredient_search(user_input)
        end
        cocktail_ingredients(ingredients)
    end

end

def cocktail_lookup
    system 'clear'
    puts "Which cocktail would you like to look up?"
    cocktail_input = gets.chomp
    lookup_array = Cocktail.all.map{|c| [c.id, c.name.downcase]}
    #binding.pry
    lookup_id = lookup_array.find{|c| c[1] == cocktail_input.downcase}
    if !lookup_id
        puts "That cocktail does not exist in our database. \nWould you like to add it? (y/n)"
        user_input = gets.chomp.downcase
        if ['y','yes'].any?(user_input)
            new_cocktail = add_cocktail(cocktail_input)
            lookup_id = new_cocktail.id
        else
            self.landing_page####needs to return to the building of the cabinet while retaining the cabinet from before
        end
        lookup_id = new_cocktail.id
    else
        lookup_id = lookup_id.first
    end
    lookup = Cocktail.all.find(lookup_id)
    lookup.cocktail_page
    self.return_to_landing
end

def add_cocktail(cocktail_input)
    ingredients = cocktail_ingredients
    puts "#{cocktail_input} ingredients: #{ingredients.map{|i| i.name}}"
    ingredient_measures = ingredients.map do |i|
        puts "What measurement of #{i.name}"
        gets.chomp
    end
    puts "How do you make #{cocktail_input}?"
    instructions = gets.chomp
    puts "What glass do you drink #{cocktail_input} from?"
    glass = gets.chomp
    new_cocktail = Cocktail.create(name: cocktail_input, instructions: instructions, glass: glass, category: 'User Submitted')
    ingredients.each do |i|
        new_cocktail.ingredients << i
        new_cocktail_ingredient = CocktailIngredient.all.find_by(cocktail_id: new_cocktail.id, ingredient_id: i.id)
        index = ingredients.index(i)
        new_cocktail_ingredient.measure = ingredient_measures[index]
        new_cocktail_ingredient.save
    end
    new_cocktail
end

def cocktail_ingredients(ing_arr=[])
    ingredients = ing_arr
    if !ingredients.empty?
        puts "Current ingredients: #{ingredients.map{|i| i.name}}"
        puts "add more ingredients or type 'end'"
        user_input = gets.chomp
        if user_input.downcase == 'end'
            return ingredients
        else
            ingredients << Ingredient.ingredient_search(user_input)
        end
    else
        puts "Add an ingredient"
        user_input = gets.chomp
        ingredients << Ingredient.ingredient_search(user_input)
    end
    cocktail_ingredients(ingredients)
end
