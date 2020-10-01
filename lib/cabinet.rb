class Cabinet
    attr_accessor :ingredients, :cocktails
    def initialize
        @ingredients = []
        @cocktails = []
    end

    def build
        if !self.ingredients.empty?
            system 'clear'
            puts "Your cabinet currently includes: #{self.ingredients.map{|i| i.name}} \n---"
            @cocktails = Cocktail.all.select{|c| c.ingredients.all?{|i| self.ingredients.include?(i)}}
            if !@cocktails.empty?
                puts "With your ingredients you could make: \n#{@cocktails.map{|c| c.name}} \n---"
            end
            puts "What else would you like to add to your liquor cabinet? If finished, type \"end\""
            user_input = gets.chomp.downcase
            if user_input != 'end'
                self.ingredients << self.ingredient_search_for_cabinet(user_input)
                self.build
            else
                self.cocktail_options
            end
        else
            system 'clear'
            puts "What would you like to add to your liquor cabinet?"
            user_input = gets.chomp.downcase
            self.ingredients << self.ingredient_search_for_cabinet(user_input)
            self.build
        end
    end

    def cocktail_options#ingredients included in cabinet
        system 'clear'
        puts "Here is a toast to you!"
        puts "-----"
        puts "With your ingredients you could make:"
        puts @cocktails.map{|c| "#{(@cocktails.index(c)+1)}. #{c.name}\n"}
        puts "-----"
        puts "Do you want to know about any of these cocktails?\nEnter number of cocktail or 'end' to return to landing page:"
        user_input = gets.chomp
        if user_input.to_i <= @cocktails.length && user_input.to_i > 0
            (@cocktails[user_input.to_i - 1]).cocktail_page
            puts "Press Enter to go back."
            user_input = gets.chomp
            cocktail_options
        elsif user_input.downcase == "end"
            CommandLineInterface.landing_page
        else
            cocktail_options
        end
    end

    def ingredient_search_for_cabinet(ingredient_input)
        lookup_array = Ingredient.all.map{|c| [c.id, c.name.downcase]}
        lookup_id = lookup_array.find{|i| i[1] == ingredient_input}
        if !lookup_id
            puts "That ingredient doesn't exist in our database, would you like to add it? (y/n)"
            user_input = gets.chomp.downcase
            if ['y','yes'].any?(user_input)
<<<<<<< HEAD
                new_ingredient = CommandLineInterface.new.add_ingredient(ingredient_input)
                lookup_id = new_ingredient.id
            else
                self.build####needs to return to the building of the cabinet while retaining the cabinet from before
=======
                new_ingredient = Ingredient.add_ingredient(ingredient_input)
                lookup_id = new_ingredient.id
            else
                build####needs to return to the building of the cabinet while retaining the cabinet from before
>>>>>>> tom
            end
        else
            lookup_id = lookup_id.first
        end
        Ingredient.all.find(lookup_id)
    end
end
