# Overall feedback:
# 
# This code gets the job done, but there are some areas where some patterns could be
# showcased that show a stronger grasp of principles important to a growing and
# shared codebase. I tried to add helpful feedback throughout the code as comments. 
# 
# Some examples of overall things that could be improved: separation of concerns, DRY,
# consistency, composition, and convention over configuration.
# 
# Please see my comments throughout the three Ruby files and let me know if you have
# any feedback or disagree with any of it. 
# 
# Thank you for the opportunity to get to know your code!
require_relative './hangman_view'
require_relative './input_validation'

# Overall this class has a lot of concerns (validation, game state, initial setup / word choice, etc.)
# It might be clearer to compose simple single-purpose objects and orchestrate them in order to perform
# the core job - playing a game of Hangman. 
# 
# By separating the concerns, it also makes the code more testable and reusable. Each component can be
# tested in isolation with unit tests, for example. There would also be less chance of side effects
# through use of instance variables as store-of-state.
class Hangman
	# Define it based on the number of attempts possible to complete the hangman figure
	MAX_INCORRECT_ATTEMPTS = 6
	# Define a set of constant words for the MVP
	# Could this be loaded from YAML / CSV / JSON? Or for extra modularity (and language support)
	# it could read from the OS level system dictionary file (macOS, Linux, Windows should all have one)
	WORD_SET = ['stare', 'annoyed', 'cats', 'paddle', 'symptomatic', 'road', 'icicle', 'surround', 'reading', 'comparison', 'transport', 'yummy', 'tax', 'paint', 'abounding', 'bathe', 'guess', 'worthless', 'white', 'clover', 'health', 'short', 'profit', 'reminiscent', 'homeless', 'painful', 'distribution', 'produce', 'optimal', 'violet', 'angry', 'likeable', 'itch', 'color', 'existence', 'provide', 'certain', 'living', 'property', 'ubiquitous', 'stamp', 'abject', 'tiger', 'top', 'blot', 'flowery', 'unsuitable', 'bed', 'pedal', 'soup']
	# Define input range for characters
	INPUT_RANGE = 'A'..'Z'
	attr_reader :won

	def initialize
		# should always call super in intialize for future-proofing
		@incorrect_attempts = 0
		@word  = WORD_SET.sample.upcase
		@guess_word_progress = Array.new(@word.length, false)
		@hangman_view = HangmanView.new
		@gameplay = true
		@won = false
		@guessed_letters = []
		define_input_validations
	end

	def play
		while(@gameplay)
			# this many parameters to the output method may be a code smell - perhaps there is a better way
			# to inject state through a higher level representation like a Guess instance or represent the 
			# player's progress through the game session with GameSession instance? Just some ideas to separate
			# concerns...
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
		# Might be better to have each validate be a class instead of using a generic class and 
		# proc-ing in the logic. (Begs question of what point the class serves if it is acting simple as a method)
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
		check_if_lost if @gameplay
	end

	def check_if_won(letter_present)
		if letter_present
			if @guess_word_progress.all? { |letter_progress|  letter_progress }
				@gameplay = false
				@won = true
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
			@won = false
			@output_hint = <<~LOSE_MESSAGE
				#{LOST_OUTPUT}
				The word was #{@word.upcase}
			LOSE_MESSAGE
		end
	end
end

class HangmanGameplay
	def initialize
		@score = { win: 0, loss: 0 }
	end

	def start
		loop do
			hangman = Hangman.new
			hangman.play
			hangman.won ? @score[:win] += 1 : @score[:loss] += 1
			puts "Press ENTER to continue or q to quit: "
			play_input = gets.chomp.downcase
			break if play_input == 'q'
		end
		puts <<~FINAL_OUT
			Thank you for playing Hangman. Your score is:
			Wins: #{@score[:win]}
			Losses: #{@score[:loss]}
		FINAL_OUT
	end
end

gameplay = HangmanGameplay.new
gameplay.start

# Overall would be great if the code base employed a linter or .editorconfig
# so there was more consistency in the code stylistic conventions. Makes it easier
# to contribute and make PRs without having a lot of "diff clutter" due to different
# conventions. Also makes the code cleaner.
