require_relative 'string_extensions'

module Displayable
  HEART = "\u2665".freeze

  def display_output
    puts "
    Turn: #{@turn_number}
    Lives: #{(HEART.red + ' ') * @lives_remaining}
    Incorrect Guesses: #{@incorrect_guesses.join(' ')}

    #{@output_array.join(' ')}
    "
  end

  def user_input_prompt
    puts "\nPlease enter a letter (case does not matter): "
  end

  def warning_prompt
    puts "\nSorry, that guess is invalid. Please try again and ensure the input is a single unused alphabetical character: "
  end

  def correct_guess_prompt(letter, occurances)
    if occurances == 1
      puts "\nGreat guess, there is #{occurances} #{letter} in the mystery word!"
    else
      puts "\nGreat guess, there are #{occurances} #{letter}'s in the mystery word!"
    end
  end

  def incorrect_guess_prompt(letter)
    puts "\nUnfortunately there are no #{letter}'s in the mystery word."
  end

  def intro_message
    puts 'Welcome to HANGMAN!'
  end

  def game_over_message(game_won, secret_word)
    case game_won
    when true
      puts "\nCongrats, you won! The secret word was #{secret_word}"
    when false
      puts "\nSorry, you lost. The secret word was #{secret_word}"
    end
  end
end
