TITLE_TEXT = "Welcome to Hangman"
INPUT_TEXT = "Enter your next guess: "
# Moving these to dedicated template files could help clean up this file by not mixing
# presentation logic concerns w/ the actual presentational components. Then for example
# another engineer or designer could change the artwork without touching the same file
# that handles win/loss display, etc.
OUTPUTS = {
  0 => <<-HANG0,
    ____________
         |     |
               |
               |
               |
               |
               |
               |
    --------------
  HANG0
  1 => <<-HANG1,
    ____________
         |     |
         O     |
               |
               |
               |
               |
               |
    --------------
  HANG1
  2 => <<-HANG2,
    ____________
         |     |
         O     |
         |     |
         |     |
               |
               |
               |
    --------------
  HANG2
  3 => <<-HANG3,
    ____________
         |     |
         O     |
        /|     |
         |     |
               |
               |
               |
    --------------
  HANG3
  4 => <<-HANG4,
    ____________
         |     |
         O     |
        /|\\    |
         |     |
               |
               |
               |
    --------------
  HANG4
  5 => <<-HANG5,
    ____________
         |     |
         O     |
        /|\\    |
         |     |
        /      |
               |
               |
    --------------
  HANG5
  6 => <<-HANG6
    ____________
         |     |
         O     |
        /|\\    |
         |     |
        / \\    |
               |
               |
    --------------
  HANG6
}

WIN_OUTPUT = <<~WIN
  ***************
  *   YOU WON   *
  ***************
WIN

LOST_OUTPUT = <<~LOSE
  ----------------
  |   YOU LOST   |
  ----------------
LOSE


class HangmanView
  # the next two methods could adhere more to the principle of DRY (Don't Repeat Yourself)
  # Logically, they are the same except some extra output. 
  #
  # One thing to look out for is if a class has two methods that take the same exact
  # parameters, there could be an opportunity for refactor.
  #
  # In this case, one could have an output method that queries game state from another
  # type of object (see comment in Hangman class about separation of concerns) and
  # `final_output` could call `output` with a flag that it's for the "final" output
  def final_output(incorrect_attempts, word, word_progress, output_hint, guessed_letters)
    clear_screen
    <<~OUT
      #{output_hint}
      #{common_output(incorrect_attempts, word, word_progress, guessed_letters)}
    OUT
  end

  def output(incorrect_attempts, word, word_progress, output_hint, guessed_letters)
    clear_screen
    <<~OUT
      #{TITLE_TEXT}
      #{common_output(incorrect_attempts, word, word_progress, guessed_letters)}
      #{output_hint}
      #{INPUT_TEXT}
    OUT
  end

  private

  def clear_screen
    Gem.win_platform? ? (system "cls") : (system "clear")
  end

  def common_output(incorrect_attempts, word, word_progress, guessed_letters)
    <<~COMMON_OUTPUT
      #{OUTPUTS.fetch(incorrect_attempts, OUTPUTS[0])}
      #{word_output(word, word_progress)}
      #{misses(guessed_letters, word)}
    COMMON_OUTPUT
  end

  def word_output(word, word_progress)
    out = ""
    word.each_char.with_index do |letter, i|
      if word_progress[i] == true
        out += letter.upcase + " "
      else
        out += "_ "
      end
    end
    # return is redundant here
    return out
  end

  def misses(guessed_letters, word)
    # assigning this string and returning shouldn't be needed; if you take away the
    # temp assignment to `out` and just leave in the interpolated string, it will 
    # be the return value for this method
    out = "Misses: #{(guessed_letters - word.chars).join(', ')}"
    return out
  end
end
