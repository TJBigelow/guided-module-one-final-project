class CommandLineInterface
    def greet
        puts "Welcome to Cocktail Finder, the command line solution to for your cocktail-finding needs!"
    end

    def landing_page
        system 'clear'
        puts "What would you like to do?"
        puts "1. Lookup Cocktail"
        puts "2. Lookup Ingredient"
        puts "3. Find out what cocktails you can make"
        puts "Input number of choice"
        user_input = gets.chomp
        if user_input == "1"
            puts "Lets lookup a cocktail"
            self.cocktail_lookup
        elsif user_input == "2"
            puts "Lets lookup an ingredient"
            self.ingredient_lookup
        elsif user_input == "3"
            puts "Lets lookup a cocktail including your ingredients"
            self.cocktail_options
        else
            self.landing_page
        end
    end

    def cocktail_page(lookup)
        system 'clear'
        puts"Cocktail Name: #{lookup.name}"
        puts "---"
        puts "Cocktail Ingredients:"
        lookup.ingredients.each do |i| 
            # binding.pry
            ci = CocktailIngredient.all.find{|ci| ci.ingredient_id == i.id && ci.cocktail_id == lookup.id}
            puts "#{ci.measure}#{i.name}"
        end
        puts "---"
        puts "Cocktail Instructions:"
        puts lookup.instructions
    end

    def ingredient_page(lookup)
        system 'clear'
        puts "Ingredient Name: #{lookup.name}"
        puts "---"
        puts "Ingredient Description:"
        puts lookup.description
    end

    def cocktail_lookup
        system 'clear'
        puts "Which cocktail would you like to look up?"
        user_input = gets.chomp.downcase
        lookup_array = Cocktail.all.map{|c| [c.id, c.name.downcase]}
        lookup_id = lookup_array.find{|c| c[1] == user_input}[0]
        lookup = Cocktail.all.find(lookup_id)
        self.cocktail_page(lookup)
        self.return_to_landing
    end

    def ingredient_lookup
        system 'clear'
        puts "Which ingredient would you like to look up?"
        user_input = gets.chomp.downcase
        lookup = ingredient_search(user_input)
        self.ingredient_page(lookup)
        puts "Want to delete this ingredient? (y/n)"
        user_input = gets.chomp.downcase
            if ['y','yes'].any?(user_input)
                puts "password?"
                user_input = gets.chomp
                if user_input == "DELETE"
                    delete_ingredient(lookup)
                else
                    puts "Incorrect Password"
                end
            end
        self.return_to_landing
    end

    def add_ingredient(ingredient_input)
        puts "Describe #{ingredient_input}"
        description = gets.chomp
        Ingredient.create(name: ingredient_input, description: description)
    end

    def delete_ingredient(ingredient_input)
        Ingredient.destroy(ingredient_input.id)
    end

    def ingredient_search(ingredient_input)
        lookup_array = Ingredient.all.map{|c| [c.id, c.name.downcase]}
        lookup_id = lookup_array.find{|i| i[1] == ingredient_input}
        
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

    def cocktail_options(cabinet=[])
        system 'clear'
        build_cabinet(cabinet)
        cocktails = Cocktail.all.select{|c| c.ingredients.all?{|i| cabinet.include?(i)}}
        system 'clear'
        puts "With your ingredients you could make:"
        puts cocktails.map{|c| c.name}
        puts "Do you want to add more ingredients to your cabinet? (y/n)"
        user_input = gets.chomp.downcase
        if ['y','yes'].any?(user_input)
            cocktail_options(cabinet)
        else
            self.return_to_landing
        end
    end

    def build_cabinet(cabinet)
        if !cabinet.empty?
            system 'clear'
            puts "Your cabinet currently includes: #{cabinet.map{|i| i.name}} \n---"
            cocktails = Cocktail.all.select{|c| c.ingredients.all?{|i| cabinet.include?(i)}}
            if !cocktails.empty?
                puts "With your ingredients you could make: \n#{cocktails.map{|c| c.name}} \n---"
            end
            puts "What else would you like to add to your liquor cabinet? If finished, type \"end\"."
            user_input = gets.chomp.downcase
            if user_input != 'end'
                cabinet << ingredient_search(user_input)
                build_cabinet(cabinet)
            end           
        else
            system 'clear'
            puts "What would you like to add to your liquor cabinet?"
            user_input = gets.chomp.downcase
            cabinet << ingredient_search(user_input)
            build_cabinet(cabinet)
        end
    end

    def return_to_landing
        puts "------\nPress enter to return to landing page"
        user_input = gets.chomp.downcase
        if user_input
            self.landing_page
        end
    end

end