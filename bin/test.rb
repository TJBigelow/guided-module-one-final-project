require 'pry'
require 'json'
require 'rest-client'

def find_or_create_random_cocktail
    response_string = RestClient.get("https://www.thecocktaildb.com/api/json/v1/1/random.php")
    response_hash = JSON.parse(response_string)["drinks"][0]
    (1..15).each{|num| find_or_create_ingredient(response_hash["strIngredient#{num}"])}
    name = response_hash["strDrink"]
    instructions = response_hash["strInstructions"]
    category = response_hash["strCategory"]
    glass = response_hash["strGlass"]
    if Cocktail.all.map{|cocktail| cocktail.name}.include?(name)
        return nil
    else
        new_cocktail = Cocktail.new(name: name, instructions: instructions, category: category, glass: glass)
    end
end


def find_or_create_ingredient(ingredient)
    response_string = RestClient.get("https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{ingredient}")
    response_hash = JSON.parse(response_string)["ingredients"][0]
    name = response_hash["strIngredient"]
    description = response_hash["strDescription"]
    if Ingredient.all.map{|ingredient| ingredient.name}.include?(name)
        return nil
    else
        new_ingredient = Ingredient.new(name: name, description: description)
    end
    # # binding.pry
    # new_ingredient = Ingredient.find_or_create_by(name: name)
    # new_ingredient.description = description
end

class Ingredient
    attr_reader :name, :description
    @@all = []
    def initialize (name:, description:)
        @name = name
        @description = description
        self.class.all << self
    end

    def self.all
        @@all
    end

    def self.all_names
        self.all.map{|ingredient| ingredient.name}
    end
end

class Cocktail
    attr_reader :name, :instructions, :category, :glass
    @@all = []
    def initialize(name:, instructions:, category:, glass:)
        @name = name
        @instructions = instructions
        @category = category
        @glass = glass
        self.class.all << self
    end

    def self.all
        @@all
    end
end

binding.pry
0