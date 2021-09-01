class Game
  attr_accessor :previous_guesses

  def initialize(lives, min_word_length, max_word_length)
    @dictionary = File.readlines('hangman_dictionary.txt', chomp: true)[0..100]
    @min_word_length = min_word_length
    @max_word_length = max_word_length
    @lives_remaining = lives
    @secret_word = random_word
    @turn_number = 1
    @previous_guesses = []
    @output_array = []
  end

  def random_word
    while (word = @dictionary.sample)
      return word if word.length.between?(@min_word_length, @max_word_length)
    end
  end

  def player_input
    user_input_prompt
    while (letter = gets.chomp.upcase)
      if @previous_guesses.include?(letter)
        warning_prompt_prior_selection(letter)
      elsif !letter.match?(/[A-Z]/) || !letter.length.eql?(1)
        warning_prompt_alphabetical
      else
        return letter
      end
    end
  end

  def update_output_array; end

  def play; end

  def player_turn
    # @previous_guesses.include?(letter) && letter.match?(/[a-z]/)
  end

  def user_input_prompt
    puts "\nPlease enter a letter (case does not matter): "
  end

  def warning_prompt_alphabetical
    puts "\nSorry, that input was not a valid single alphabetical character. Please guess again: "
  end

  def warning_prompt_prior_selection(letter)
    puts "\nSorry, #{letter} has already been guessed. Please guess again: "
  end
end

@game = Game.new(6, 5, 12)
puts @game.random_word
