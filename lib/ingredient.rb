class Ingredient < ActiveRecord::Base
    has_many :cocktail_ingredients
    has_many :cocktails, through: :cocktail_ingredients

    def ingredient_page
        system 'clear'
        puts "Ingredient Name: #{self.name}\n---\nIngredient Description:\n#{self.description}"
    end

    def self.ingredient_lookup
        system 'clear'
        puts "Which ingredient would you like to look up?"
        user_input = gets.chomp
        lookup = self.ingredient_search(user_input)
        lookup.ingredient_page
        lookup.what_you_could_make
        CommandLineInterface.new.return_to_landing
    end

    def self.ingredient_search(ingredient_input)
        lookup_array = Ingredient.all.map{|c| [c.id, c.name.downcase]}
        lookup_id = lookup_array.find{|i| i[1] == ingredient_input.downcase}
        if !lookup_id
            puts "That ingredient doesn't exist in our database, would you like to add it? (y/n)"
            user_input = gets.chomp.downcase
            if ['y','yes'].any?(user_input)
                new_ingredient = self.add_ingredient(ingredient_input)
                lookup_id = new_ingredient.id
            else
                CommandLineInterface.new.landing_page####needs to return to the building of the cabinet while retaining the cabinet from before
            end
        else
            lookup_id = lookup_id.first
        end
        Ingredient.all.find(lookup_id)
    end

    def what_you_could_make#find all cocktails with a particular ingredient
        cocktails = CocktailIngredient.all.map do |ci|
            if ci.ingredient_id == self.id
                ci.cocktail_id
                end
        end
        list = cocktails.select {|c| c}
        cocktail_obj = Cocktail.all.select {|c| list.include?(c.id)}
        k = cocktail_obj.map {|co| co.name}
        puts "---\nThese are some of the cocktails you can make with #{self.name}:"
        puts k.sample(4)
    end

    def self.add_ingredient(ingredient_input)
        puts "Describe #{ingredient_input}"
        description = gets.chomp
        Ingredient.create(name: ingredient_input, description: description)
    end
end
