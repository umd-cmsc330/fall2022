require_relative 'input_controller'
require_relative '../models/game_board'

# ===========================================
# =====DON'T modify the following code=======
# ===========================================

PLAYER_ONE = 1
PLAYER_TWO = 2
RANDOM_ATTACK_SIZE = 35

# GameController responsible for the game logic
# Reads files by calling input_controller and take
class GameController
    def initialize(players)
        @players = players
        @game_board = nil, nil
        @attacks = [], []
    end

    # setup and start the game
    def start_game
        @game_board = load_ships(@players.game_board_1, PLAYER_ONE), load_ships(@players.game_board_2, PLAYER_TWO)
        @attacks = load_attacks(@players.attack_1, PLAYER_ONE), load_attacks(@players.attack_2, PLAYER_TWO)
        puts ""
        play_game
    end

    # load the GameBoard for the player # (calls input_controller function)
    def load_ships(game_board_file, player_number)
        player_game_board = read_ships_file(game_board_file)
        unless player_game_board
            raise "Input Error\nError loading Player #{player_number}'s ships file. " +
                "Make sure the ship file provided exists and the format is correct (i.e, 5 ships per player)."
        end
        player_game_board
    end

    # load the attack strategy file for the player #
    # Creates random attack moves if file is not provided.
    def load_attacks(attack_file, player)
        if attack_file.nil?
            puts "No attack file found for Player #{player}. Using random generator instead."
            return generate_random_attacks RANDOM_ATTACK_SIZE
        end

        attacks = read_attacks_file(attack_file)
        unless attacks
            raise "Input Error\nError reading Player #{player}'s attack file. " +
                "Make sure the attack strategy file provided exists and the format is correct."
        end

        attacks
    end

    # take turns and perform attacks
    def play_game
        winner = -1
        if @attacks[0].empty? || @attacks[1].empty?
            raise "Each player must have AT LEAST one attack position. " +
                "Player-#{@attacks[0].empty? ? 1 : 2} has 0 attacks."
        end

        while true
            winner = take_turn_check_winner PLAYER_ONE
            break if winner != -1

            winner = take_turn_check_winner PLAYER_TWO
            break if winner != -1
        end

        #print end of game message

        msg = '˗ ˏ ˋ   ˎ ˊ ˗ ' * 2
        puts "\n#{msg}\nYoo-hoooo!\nPlayer #{winner} has won the game!\n#{msg}\n\n"
        puts "#{'=' * 20}\nPlayer-1 GameBoard"
        puts @game_board[PLAYER_ONE - 1]
        puts "#{'=' * 20}\nPlayer-2 GameBoard"
        puts @game_board[PLAYER_TWO - 1]
    end

    # player takes turn and performs attack.
    # checks for winner and return the winner number if there is one.
    # If no winner, returns -1
    def take_turn_check_winner(player)
        other_player = player == PLAYER_ONE ? PLAYER_TWO : PLAYER_ONE

        # skip invalid attacks
        did_attack = false
        until did_attack
            did_attack = perform_attack_on(player, other_player)
        end

        # if one player ran out of attack moves, stop the game and announce the winner
        if player == PLAYER_TWO
            unless has_valid_attack?(PLAYER_ONE) && has_valid_attack?(PLAYER_TWO)
                p_success =  @game_board[other_player - 1].num_successful_attacks
                other_p_success =  @game_board[player - 1].num_successful_attacks

                puts "Game result:\nP#{other_player} success: #{other_p_success}, P#{player} success: #{p_success}"
                if p_success > other_p_success
                    return player
                else
                    return other_player
                end
            end
        end

        if @game_board[other_player - 1].all_sunk?
            p_success =  @game_board[other_player - 1].num_successful_attacks
            other_p_success =  @game_board[player - 1].num_successful_attacks

            puts "Game result:\nP#{player} success: #{p_success},  P#{other_player} success: #{other_p_success}"
            puts "All player #{other_player} ships sunk!"
            return player
        end
        -1
    end

    # Perform a single attack from <player> to its opponent
    def perform_attack_on(player, other_player)
        player_attack_strategy = @attacks[player - 1]
        # player attacks other player
        result = @game_board[other_player - 1].attack_pos(player_attack_strategy.shift)

        result != nil
    end

    # generate a list of random attack positions
    def generate_random_attacks(size)
        attacks = []
        rng = Random.new
        for _ in 0...size
            attacks.append Position.new(rng.rand(1..@game_board[0].max_row), rng.rand(1..@game_board[0].max_column))
        end
        attacks
    end

    def has_valid_attack?(player)
        player_attack_strategy = @attacks[player - 1]
        player_attack_strategy.each do |position|
            return true if position_valid? position
        end
        false
    end

    def position_valid?(position)
        is_valid = Proc.new { |x, max| x <= max && x >= 1 }

        is_valid.call(position.row, @game_board[0].max_row) && is_valid.call(position.column, @game_board[0].max_column)
    end
end
