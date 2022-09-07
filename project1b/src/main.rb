require_relative 'controllers/game_controller'

# ===========================================
# =====DON'T modify the following code=======
# ===========================================

Players = Struct.new(:game_board_1, :game_board_2, :attack_1, :attack_2)

def parser(args)
    players = Players.new(nil, nil)
    raise ArgumentError unless args.size >= 2
    players.game_board_1 = args[0]
    players.game_board_2 = args[1]
    players.attack_1 = args[2] if args.size >= 3
    players.attack_2 = args[3] if args.size >= 4

    players
end

def main(files=ARGV)
    begin
        players = parser(files)
        game_controller = GameController.new(players)
        game_controller.start_game
    rescue ArgumentError
        puts "Invalid number of arguments."
        puts "Usage: main.rb <p1_pos_file> <p2_pos_file> <p1_attacks_file> <p2_attacks_file>"
        exit(1)
    end
end

main
