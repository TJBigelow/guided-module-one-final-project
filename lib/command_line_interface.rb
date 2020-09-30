class CommandLineInterface
    def greet
        puts "Welcome to Cocktail Finder, the command line solution for your cocktail-finding needs!"
    end

    def landing_page
        system 'clear'
        puts "What would you like to do?\n1. Lookup Cocktail\n2. Lookup Ingredient\n3. Find out what cocktails you can make\nInput number of choice or type 'quit' to exit program."
        user_input = gets.chomp
        if user_input == "1"
            puts "Lets lookup a cocktail!"
            sleep(1.5)###
            self.cocktail_lookup
        elsif user_input == "2"
            puts "Lets lookup an ingredient!"
            sleep(1.5)###
            self.ingredient_lookup
        elsif user_input == "3"
            puts "Lets lookup a cocktail including your ingredients!"
            new_cabinet = Cabinet.new
            sleep(1.5)###
            new_cabinet.build
        elsif user_input == "quit"
            system 'clear'
            puts "We are sorry to see you go."
            sleep(2)
            system 'clear'
            exit
        else
            self.landing_page
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
                self.landing_page
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
                ingredients << ingredient_search(user_input)
            end
        else      
            puts "Add an ingredient"
            user_input = gets.chomp.downcase
            ingredients << ingredient_search(user_input)
        end
        cocktail_ingredients(ingredients)
    end

    def ingredient_lookup
        system 'clear'
        puts "Which ingredient would you like to look up?"
        user_input = gets.chomp
        lookup = ingredient_search(user_input)
        lookup.ingredient_page
        self.what_you_could_make(lookup)
        self.return_to_landing
    end

    def add_ingredient(ingredient_input)
        puts "Describe #{ingredient_input}"
        description = gets.chomp
        Ingredient.create(name: ingredient_input, description: description)
    end

    def ingredient_search(ingredient_input)
        lookup_array = Ingredient.all.map{|c| [c.id, c.name.downcase]}
        lookup_id = lookup_array.find{|i| i[1] == ingredient_input.downcase}
        if !lookup_id
            puts "That ingredient doesn't exist in our database, would you like to add it? (y/n)"
            user_input = gets.chomp.downcase
            if ['y','yes'].any?(user_input)
                new_ingredient = add_ingredient(ingredient_input)
                lookup_id = new_ingredient.id
            else
                self.landing_page
            end
        else
            lookup_id = lookup_id.first
        end
        Ingredient.all.find(lookup_id)
    end

    def what_you_could_make(lookup)#find all cocktails with a particular ingredient
        cocktails = CocktailIngredient.all.map do |ci|
            if ci.ingredient_id == lookup.id
                ci.cocktail_id
                end
        end
        list = cocktails.select {|c| c}
        cocktail_obj = Cocktail.all.select {|c| list.include?(c.id)}
        k = cocktail_obj.map {|co| co.name}
        puts "---\nThese are some of the cocktails you can make with #{lookup.name}:"
        puts k.sample(4)
    end

    def return_to_landing
        puts "------\nPress enter to return to main menu."
        user_input = gets.chomp.downcase
        if user_input
            self.landing_page
        end
    end
end
