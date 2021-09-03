module ClassDisplayable
  SECTION_BREAK = '-' * 100

  def intro_message(min_length, max_length, lives)
    <<~HEREDOC
    
    #{SECTION_BREAK}

    Welcome to #{'HANGMAN'.blue}!
    
    The rules of the game are simple: 
    
    - The computer will randomly select a secret word between #{min_length} and #{max_length} letters
    - Each turn you will be able to guess one letter from the word
    - Solve the word before making #{lives} incorrect guess(es) and you win!

    HEREDOC
  end

  def display_saved_games(hash)
    output = ''
    hash.each { |key, value| output += "#{key.to_s.blue}:  #{value}\n" }

    <<~HEREDOC

    Saved Games:
    
    #{output}
    HEREDOC
  end

  def new_game_prompt
    <<~HEREDOC

    Starting new game...
    #{SECTION_BREAK}
    HEREDOC
  end

  def load_game_prompt(filename)
    <<~HEREDOC
    
    Loading #{filename}...
    #{SECTION_BREAK}
    HEREDOC
  end

  def game_mode_prompt
    <<~HEREDOC
    Enter 1 to start a new game
    Enter 2 to load a previously saved game
    HEREDOC
  end

  def saved_game_prompt
    'Please input a number corresponding to a file listed above: '
  end

  def warning_prompt_invalid
    "\nSorry, that input is invalid".red
  end
end
