require_relative 'game'

min_word_length = 5
max_word_length = 12
lives = 6

loop do
  game = Game.create_game(min_word_length, max_word_length, lives)
  game.play
  break game.end unless game.restart
end
