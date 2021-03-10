# This class would be great as a base class to inherit from. 
# Semantically the descendant classes could describe their job-to-be-done that way.
# 
# For example, SingleCharacterValidator, DuplicateGuessValidator, etc.
# 
# As a nice side effect your backtraces are easier if there's issues, and you can encapsulate
# custom messaging better in those places.
class InputValidation
	attr_reader :message
	def initialize(message, &validator)
		@message = message
		@validator = validator
	end

	def valid?(input)
		if @validator.call(input)
			return true
		end
		return false
	end
end
