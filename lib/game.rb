require_relative 'instance_displayable'
require_relative 'class_displayable'
require 'yaml'

class Game
  include InstanceDisplayable
  extend ClassDisplayable
  attr_accessor :previous_guesses, :secret_word

  @@dictionary = File.readlines('hangman_dictionary.txt', chomp: true)

  def initialize(min_word_length, max_word_length, lives)
    @word_length = [min_word_length, max_word_length]
    @lives_remaining = lives
    @secret_word = random_word.upcase
    @game_won = false
    @placeholder_char = '_'
    @correct_guesses = []
    @incorrect_guesses = []
    @output_array = Array.new(@secret_word.length, @placeholder_char)
  end

  def self.user_input(prompt, warning, match_criteria)
    puts prompt
    input = gets.chomp.upcase
    raise warning unless input.match?(match_criteria)

    input
  rescue StandardError => e
    puts e
    retry
  end

  def self.open_saved_file
    saved_games = find_saved_files
    return saved_games if saved_games.nil?

    display_saved_files(saved_games)
    file_num = get_file_num(saved_games)
    puts load_game_prompt(saved_games[file_num])
    load_saved_file("saved_games/#{saved_games[file_num]}")
  end

  def self.find_saved_files
    saved_games = Dir.glob('*.yaml', base: 'saved_games')
    if saved_games.empty?
      puts no_saved_games_prompt
      return nil
    end
    Hash[(1..saved_games.size).zip saved_games]
  end

  def self.display_saved_files(hash)
    puts display_saved_games(hash)
  end

  def self.load_saved_file(filepath)
    saved_game = File.read(filepath)
    YAML.load(saved_game)
  end

  def self.get_file_num(games_list)
    user_input(saved_game_prompt, warning_prompt_invalid, /#{games_list.keys}/)
      .to_i
  end

  def self.game_mode
    Game.user_input(Game.game_mode_prompt, Game.warning_prompt_invalid, /[1-2]/)
  end

  def self.create_game(min_word_length, max_word_length, lives)
    puts intro_message(min_word_length, max_word_length, lives)
    loop do
      mode = game_mode
      if mode == '1'
        puts new_game_prompt
        return new(min_word_length, max_word_length, lives)
      else
        loaded_game = open_saved_file
        return loaded_game unless loaded_game.nil?
      end
    end
  end

  def random_word
    while (word = @@dictionary.sample)
      return word if word.length.between?(@word_length[0], @word_length[1])
    end
  end

  def get_player_input
    loop do
      input =
        Game.user_input(
          user_input_prompt,
          Game.warning_prompt_invalid,
          /^[A-Z]$|^SAVE$|^QUIT$/
        )
      return input if unused_input?(input)

      puts warning_prompt_used(input)
    end
  end

  def unused_input?(string)
    !@correct_guesses.include?(string) && !@incorrect_guesses.include?(string)
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
    puts display_output
    while player_turn
      if @lives_remaining.zero? || game_won?
        break puts game_over_message(@game_won, @secret_word)
      end
    end
  end

  def player_turn
    player_input = get_player_input

    case player_input
    when 'SAVE'
      save
      false
    when 'QUIT'
      false
    else
      evaluate_guess(player_input)
      puts display_output
      true
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

  def save
    serialized_file = serialize
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    filename = "#{@output_array.join(' ')}.yaml"
    filepath = "saved_games/#{filename}"
    File.write(filepath, serialized_file)
    puts save_game_message(filename)
  end

  def serialize
    YAML.dump(self)
  end
end
