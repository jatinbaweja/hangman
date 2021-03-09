TITLE_TEXT = "Welcome to Hangman"
INPUT_TEXT = "Enter your next guess: "
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
  def final_output(incorrect_attempts, word, word_progress, output_hint, guessed_letters)
    system "clear"
    <<~OUT
      #{output_hint}
      #{common_output(incorrect_attempts, word, word_progress, guessed_letters)}
    OUT
  end

  def output(incorrect_attempts, word, word_progress, output_hint, guessed_letters)
    system "clear"
    <<~OUT
      #{TITLE_TEXT}
      #{common_output(incorrect_attempts, word, word_progress, guessed_letters)}
      #{output_hint}
      #{INPUT_TEXT}
    OUT
  end

  private

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
    return out
  end

  def misses(guessed_letters, word)
    out = "Misses: #{(guessed_letters - word.chars).join(', ')}"
    return out
  end
end