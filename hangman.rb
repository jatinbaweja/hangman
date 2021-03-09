require_relative './hangman_view'

class Hangman
	# Define it based on the number of attempts possible to complete the hangman figure
	MAX_INCORRECT_ATTEMPTS = 6
	# Define a set of constant words for the MVP
	WORD_SET = ['stare', 'annoyed', 'cats', 'paddle', 'symptomatic', 'road', 'icicle', 'surround', 'reading', 'comparison', 'transport', 'yummy', 'tax', 'paint', 'abounding', 'bathe', 'guess', 'worthless', 'white', 'clover', 'health', 'short', 'profit', 'reminiscent', 'homeless', 'painful', 'distribution', 'produce', 'optimal', 'violet', 'angry', 'likeable', 'itch', 'color', 'existence', 'provide', 'certain', 'living', 'property', 'ubiquitous', 'stamp', 'abject', 'tiger', 'top', 'blot', 'flowery', 'unsuitable', 'bed', 'pedal', 'soup']

	def initialize
		@incorrect_attempts = 0
		@word  = WORD_SET.sample.upcase
		@guess_word_progress = Array.new(@word.length, false)
		@hangman_view = HangmanView.new
		@gameplay = true
	end

	def play
		while(@gameplay == true)
			puts @hangman_view.output(@incorrect_attempts, @word, @guess_word_progress)
			input = gets.chomp.upcase
			evaluate_attempt(input)
		end
		puts @final_output
	end

	private

	def evaluate_attempt(input)
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
				@final_output = "You Won. Thank you for playing Hangman. The word was #{@word.upcase}"
			end
		else
			@incorrect_attempts += 1
		end
	end

	def check_if_lost
		if @incorrect_attempts == MAX_INCORRECT_ATTEMPTS
			@gameplay = false
			@final_output = "You lost. Thank you for playing Hangman. The word was #{@word.upcase}"
		end
	end
end

hg = Hangman.new
hg.play
