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
            cocktail_lookup
        elsif user_input == "2"
            puts "Lets lookup an ingredient!"
            sleep(1.5)###
            Ingredient.ingredient_lookup
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

    def return_to_landing
        puts "------\nPress enter to return to main menu."
        user_input = gets.chomp.downcase
        if user_input
            self.landing_page
        end
    end
end
