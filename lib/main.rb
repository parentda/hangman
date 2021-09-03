require_relative 'game'

min_word_length = 5
max_word_length = 12
lives = 6

loop do
  puts Game.intro_message(min_word_length, max_word_length, lives)
  game =
    loop do
      game_mode = Game.game_mode
      if game_mode == '1'
        puts Game.new_game_prompt
        break Game.new(min_word_length, max_word_length, lives)
      else
        loaded_game = Game.open_file
        break loaded_game unless loaded_game.nil?
      end
    end
  game.play
  break game.end unless game.restart
end
