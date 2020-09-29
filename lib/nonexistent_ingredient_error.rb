class NonexistentIngredientError < StandardError
    def initialize(message="That ingredient doesn't exist in our database")
        @message = message
    end
end