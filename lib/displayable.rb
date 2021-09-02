require_relative 'string_extensions'

module Displayable
  HEART = "\u2665".freeze

  def display_output
    puts "
    Lives: #{(HEART.red + ' ') * @lives_remaining}
    Incorrect Guesses: #{@incorrect_guesses.join(' ').red}

    #{@output_array.join(' ').green}
    "
  end

  def user_input_prompt
    puts <<~HEREDOC
    (At any time you may enter 'save' to save and exit, or 'quit' to exit the game without saving)
    Please enter a previously unused letter to make a guess: 
    HEREDOC
  end

  def warning_prompt
    puts "\nSorry, that guess is invalid".red
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
    puts <<~HEREDOC
    
    #{'-' * 100}

    Welcome to HANGMAN!
    
    HEREDOC
  end

  def game_over_message(game_won, secret_word)
    case game_won
    when true
      puts "\nCongrats, you won! The secret word was #{secret_word.green}"
    when false
      puts "\nSorry, you lost. The secret word was #{secret_word.red}"
    end
  end

  def restart_message
    puts "\nWould you like to play again? Enter (Y/y) to start a new game or any other key to quit:"
  end

  def exit_message
    puts "\nThanks for playing!"
  end
end
