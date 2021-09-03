require_relative 'game'

min_word_length = 5
max_word_length = 12
lives = 6

loop do
  puts Game.intro_message(min_word_length, max_word_length, lives)
  game_mode =
    Game.user_input(Game.game_mode_prompt, Game.warning_prompt_invalid, /[1-2]/)
  game =
    if game_mode == '1'
      puts Game.new_game_prompt
      Game.new(min_word_length, max_word_length, lives)
    else
      Game.open_file
    end
  game.play
  break game.end unless game.restart
end
