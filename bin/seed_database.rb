require_relative '../config/environment'

def api_response(url, key)
    response_string = RestClient.get(url)
    JSON.parse(response_string)[key]
    # creates array of hashes from key in API
end

def find_or_create_cocktails_from_first_letter(letter)
    cocktail_array = api_response("https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}", "drinks")
    # creates array of hashes of drink data from API
    if cocktail_array
        # skips letters without cocktails such as 'U' and 'X'
        cocktail_array.each do |cocktail_hash|
            # iterates though each cocktail in drinks array
            name = cocktail_hash["strDrink"]
            instructions = cocktail_hash["strInstructions"]
            category = cocktail_hash["strCategory"]
            glass = cocktail_hash["strGlass"]
            # assigns attributes based on API data
            if Cocktail.all.map{|cocktail| cocktail.name}.exclude?(name)
                new_cocktail = Cocktail.create(name: name, instructions: instructions, category: category, glass: glass)
                #creates cocktail if it doesn't already exist
                create_ingredients_from_cocktail(cocktail_hash, new_cocktail)
                #iterates through the potential 15 ingredients of the cocktail, creating any that don't exist already
            end
        end
    end
end

def find_or_create_ingredient(ingredient)
    ingredient_hash = api_response("https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{ingredient.to_ascii}", "ingredients")[0]
    # creates hash of ingredient data from API
    name = ingredient_hash["strIngredient"]
    description = ingredient_hash["strDescription"]
    # assigns attributes based on API data
    if Ingredient.all.map{|ingredient| ingredient.name}.exclude?(name)
        Ingredient.create(name: name, description: description)
        # creates ingredient row in table if not already there
    else
        Ingredient.all.find_by(name: name)
        # returns ingredient row if already there
    end
end

def create_ingredients_from_cocktail(cocktail_hash, new_cocktail)
    (1..15).each do |num| 
        # iterates through 15 possible ingredients
        if cocktail_hash["strIngredient#{num}"] == nil
            break
            # ends at the first nonexistent ingredient
        else
            new_cocktail.ingredients << find_or_create_ingredient(cocktail_hash["strIngredient#{num}"])
            # creates ingredient if nonexistent, then adds to cocktail
        end
    end
end

('a'..'z').each do |letter|
    find_or_create_cocktails_from_first_letter(letter)
end
('0'..'9').each do |letter|
    find_or_create_cocktails_from_first_letter(letter)
end
# iterates through every letter and number creating cocktails and their ingredients from the API