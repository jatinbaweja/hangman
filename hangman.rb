require_relative './hangman_view'
require_relative './input_validation'

class Hangman
	# Define it based on the number of attempts possible to complete the hangman figure
	MAX_INCORRECT_ATTEMPTS = 6
	# Define a set of constant words for the MVP
	WORD_SET = ['stare', 'annoyed', 'cats', 'paddle', 'symptomatic', 'road', 'icicle', 'surround', 'reading', 'comparison', 'transport', 'yummy', 'tax', 'paint', 'abounding', 'bathe', 'guess', 'worthless', 'white', 'clover', 'health', 'short', 'profit', 'reminiscent', 'homeless', 'painful', 'distribution', 'produce', 'optimal', 'violet', 'angry', 'likeable', 'itch', 'color', 'existence', 'provide', 'certain', 'living', 'property', 'ubiquitous', 'stamp', 'abject', 'tiger', 'top', 'blot', 'flowery', 'unsuitable', 'bed', 'pedal', 'soup']
	# Define input range for characters
	INPUT_RANGE = 'A'..'Z'

	def initialize
		@incorrect_attempts = 0
		@word  = WORD_SET.sample.upcase
		@guess_word_progress = Array.new(@word.length, false)
		@hangman_view = HangmanView.new
		@gameplay = true
		@guessed_letters = []
		define_input_validations
	end

	def play
		while(@gameplay == true)
			puts @hangman_view.output(@incorrect_attempts, @word, @guess_word_progress, @output_hint, @guessed_letters)
			input = gets.chomp.upcase
			valid = validate_input(input)
			evaluate_attempt(input) if valid
		end
		puts @hangman_view.final_output(@incorrect_attempts, @word, @guess_word_progress, @output_hint, @guessed_letters)
	end

	private

	def define_input_validations
		@input_validations = []
		@input_validations.push(InputValidation.new("Please enter single character only") { |input| input.length == 1 })
		@input_validations.push(InputValidation.new("Input should be part of range #{INPUT_RANGE.min}-#{INPUT_RANGE.max}") { |input| INPUT_RANGE.include?(input) })
		@input_validations.push(InputValidation.new("Cannot guess same letter again") { |input| !@guessed_letters.include?(input) })
	end

	def validate_input(input)
		@output_hint = ""
		failed_validation = @input_validations.find { |validation| !validation.valid?(input) }
		if failed_validation
			@output_hint = failed_validation.message
			return false
		end
		return true
	end

	def evaluate_attempt(input)
		@guessed_letters.push(input)
		letter_present = false
		@word.each_char.with_index do |letter, i|
			if(letter == input)
				@guess_word_progress[i] = true
				letter_present = true
			end
		end
		check_if_won(letter_present)
		check_if_lost if @gameplay != false
	end

	def check_if_won(letter_present)
		if letter_present
			if @guess_word_progress.all? { |letter_progress|  letter_progress }
				@gameplay = false
				@output_hint = <<~WIN_MESSAGE
					#{WIN_OUTPUT}
				WIN_MESSAGE
			end
		else
			@incorrect_attempts += 1
		end
	end

	def check_if_lost
		if @incorrect_attempts == MAX_INCORRECT_ATTEMPTS
			@gameplay = false
			@output_hint = <<~LOSE_MESSAGE
				#{LOST_OUTPUT}
				The word was #{@word.upcase}
			LOSE_MESSAGE
		end
	end
end

class HangmanGameplay
	def start
		loop do
			hangman = Hangman.new
			hangman.play
			puts "Press ENTER to continue or q to quit: "
			play_input = gets.chomp.downcase
			break if play_input == 'q'
		end
		puts "Thank you for playing Hangman"
	end
end

gameplay = HangmanGameplay.new
gameplay.start
