class Game
  attr_accessor :previous_guesses, :secret_word

  @@dictionary = File.readlines('hangman_dictionary.txt', chomp: true)[0..100]

  def initialize(lives, min_word_length, max_word_length)
    @word_length = [min_word_length, max_word_length]
    @lives_remaining = lives
    @secret_word = random_word.upcase
    @turn_number = 1
    @game_won = false
    @placeholder_char = '_'
    @correct_guesses = []
    @incorrect_guesses = []
    @output_array = Array.new(@secret_word.length, @placeholder_char)
  end

  def random_word
    while (word = @@dictionary.sample)
      return word if word.length.between?(@word_length[0], @word_length[1])
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
         !@correct_guesses.include?(string) &&
         !@incorrect_guesses.include?(string)
      true
    else
      false
    end
  end

  def update_output_array(letter)
    (0...@secret_word.length)
      .find_all { |idx| @secret_word[idx] == letter }
      .each { |idx| @output_array[idx] = letter }
  end

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

  def play
    intro_message
    player_turn until @lives_remaining.zero? || game_won?
    game_over_message(@game_won, @secret_word)
  end

  def player_turn
    display_output
    player_guess = player_input
    evaluate_guess(player_guess)
    @turn_number += 1
  end

  def game_won?
    @game_won = true unless @output_array.include?(@placeholder_char)
  end
end

@game = Game.new(6, 5, 12)
# puts @game.random_word
