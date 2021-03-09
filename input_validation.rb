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