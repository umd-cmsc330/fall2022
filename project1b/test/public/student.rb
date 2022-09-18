require_relative "../../src/controllers/input_controller.rb"
require_relative "../../src/controllers/game_controller.rb"
require_relative "../../src/models/game_board.rb"
require_relative "../../src/models/position.rb"
require_relative "../../src/models/ship.rb"

gb = GameBoard.new 10,10
ship1 = Ship.new(Position.new(5,5), "Down", 5)
gb.add_ship(ship1)
puts gb.to_s