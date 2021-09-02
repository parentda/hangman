class Game
  attr_accessor :previous_guesses, :secret_word

  def initialize(lives, min_word_length, max_word_length)
    @dictionary = File.readlines('hangman_dictionary.txt', chomp: true)[0..100]
    @min_word_length = min_word_length
    @max_word_length = max_word_length
    @lives_remaining = lives
    @secret_word = random_word
    @turn_number = 1
    @placeholder_char = '_'
    @correct_guesses = []
    @incorrect_guesses = []
    @output_array = Array.new(@secret_word.length, @placeholder_char)
  end

  def random_word
    while (word = @dictionary.sample)
      return word if word.length.between?(@min_word_length, @max_word_length)
    end
  end

  def player_input
    user_input_prompt
    while (letter = gets.chomp.upcase)
      break letter if valid_input?(letter)

      warning_prompt
    end
  end

  def valid_input?(string)
    if string.match?(/[A-Z]/) && string.length.eql?(1) &&
         !@previous_guesses.include?(string)
      true
    else
      false
    end
  end

  def update_output_array(letter); end

  def evaluate_guess(letter)
    if @secret_word.include?(letter)
      @correct_guesses << letter
      update_output_array(letter)
      correct_guess_prompt(letter, @secret_word.count(letter))
    else
      @incorrect_guesses << letter
      @lives_remaining -= 1
      incorrect_guess_prompt(letter)
    end
  end

  def play; end

  def player_turn
    player_guess = player_input
    evaluate_guess(player_guess)
    @turn_number += 1
  end

  def display_output
    puts @output_array.join(' ')
  end

  def game_over?
    !@output_array.include?(@placeholder_char)
  end

  def user_input_prompt
    puts "\nPlease enter a letter (case does not matter): "
  end

  def warning_prompt
    puts "\nSorry, the input must be an unused single alphabetical character. Please guess again: "
  end

  def correct_guess_prompt(letter, occurances)
    puts "\nGreat guess, there are #{occurances} #{letter}'s in the mystery word!"
  end

  def incorrect_guess_prompt(letter)
    puts "\nUnfortunately there are no #{letter}'s in the mystery word."
  end
end

@game = Game.new(6, 5, 12)
puts @game.random_word
