require_relative 'game'

loop do
  game = Game.new(6, 5, 12)
  game.play
  break game.end unless game.restart
end
