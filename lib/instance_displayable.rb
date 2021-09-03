require_relative 'string_extensions'

module InstanceDisplayable
  HEART = "\u2665".freeze

  def display_output
    "
    Lives: #{(HEART.red + ' ') * @lives_remaining}
    Incorrect Guesses: #{@incorrect_guesses.join(' ').red}

    #{@output_array.join(' ').green}
    "
  end

  def user_input_prompt
    <<~HEREDOC
    (At any time you may enter 'save' to save and exit, or 'quit' to exit the game without saving)
    Please enter a previously unused letter to make a guess: 
    HEREDOC
  end

  def warning_prompt_used(letter)
    "\nSorry, #{letter} has already been guessed".red
  end

  def correct_guess_prompt(letter, occurances)
    if occurances == 1
      "\nGreat guess, there is #{occurances} #{letter} in the mystery word!"
    else
      "\nGreat guess, there are #{occurances} #{letter}'s in the mystery word!"
    end
  end

  def incorrect_guess_prompt(letter)
    "\nUnfortunately there are no #{letter}'s in the mystery word."
  end

  def game_over_message(game_won, secret_word)
    case game_won
    when true
      "\nCongrats, you won! The secret word was #{secret_word.green}"
    when false
      "\nSorry, you lost. The secret word was #{secret_word.red}"
    end
  end

  def restart_message
    "\n\nWould you like to play again? Enter (Y/y) to start a new game/load a saved game, or any other key to quit:"
  end

  def exit_message
    "\nThanks for playing!"
  end

  def save_game_message(filepath)
    "\nYour game has been saved as:  #{filepath.blue}"
  end
end
