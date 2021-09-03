require_relative 'displayable'
require 'yaml'

class Game
  include Displayable
  attr_accessor :previous_guesses, :secret_word

  @@dictionary = File.readlines('hangman_dictionary.txt', chomp: true)[0..100]

  def initialize(lives, min_word_length, max_word_length)
    @word_length = [min_word_length, max_word_length]
    @lives_remaining = lives
    @secret_word = random_word.upcase
    @game_won = false
    @game_in_progress = false
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

  def user_input(prompt, warning, regex_match)
    loop do
      puts prompt
      input = gets.chomp.upcase
      break input if input.match?(regex_match)

      puts warning
    end
  end

  def get_player_input
    loop do
      input =
        user_input(
          user_input_prompt,
          warning_prompt_invalid,
          /^[A-Z]$|^SAVE$|^QUIT$/
        )
      return input if unused_input?(input)

      puts warning_prompt_used(input)
    end
  end

  def unused_input?(string)
    if (
         !@correct_guesses.include?(string) &&
           !@incorrect_guesses.include?(string)
       )
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
      puts correct_guess_prompt(letter, @secret_word.count(letter))
    else
      @incorrect_guesses << letter
      @lives_remaining -= 1
      puts incorrect_guess_prompt(letter)
    end
  end

  def play
    puts intro_message
    puts display_output
    player_turn until @lives_remaining.zero? || game_won?
    puts game_over_message(@game_won, @secret_word)
  end

  def player_turn
    player_input = get_player_input

    case player_input
    when 'SAVE'
    when 'QUIT'
    else
      evaluate_guess(player_input)
      puts display_output
    end
  end

  def game_won?
    @game_won = true unless @output_array.include?(@placeholder_char)
  end

  def restart
    puts restart_message
    gets.chomp.downcase == 'y'
  end

  def end
    puts exit_message
  end

  def save; end

  def serialize
    YAML.dump(self)
  end

  def self.load(filename); end
  #make a more generic user input function? user_input(prompt, valid_inputs, warning_message)
end
