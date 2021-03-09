require_relative './hangman_view'

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

	def validate_input(input)
		@output_hint = ""
		if input.length != 1
			@output_hint = "Please enter single character only"
			return false
		end
		if !INPUT_RANGE.include?(input)
			@output_hint = "Input should be part of range #{INPUT_RANGE.min}-#{INPUT_RANGE.max}"
			return false
		end
		if @guessed_letters.include?(input)
			@output_hint = "Cannot guess same letter again"
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
					Thank you for playing Hangman. The word was #{@word.upcase}
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
				Thank you for playing Hangman. The word was #{@word.upcase}
			LOSE_MESSAGE
		end
	end
end

hg = Hangman.new
hg.play
