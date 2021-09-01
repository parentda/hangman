class Game
  def initialize(lives, min_word_length, max_word_length)
    @dictionary = File.readlines('hangman_dictionary.txt', chomp: true)
    @min_word_length = min_word_length
    @max_word_length = max_word_length
    @lives_remaining = lives
    @secret_word = secret_word
    @turn_number = 1
    @correct_guesses = []
    @incorrect_guesses = []
  end

  def secret_word
    while (word = @dictionary.sample)
      return word if word.length.between?(@min_word_lenth, @max_word_length)
    end
  end
end

game = Game.new
puts game.secret_word(5, 12)
