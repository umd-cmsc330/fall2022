require "minitest/autorun"
require_relative "../../src/controllers/input_controller.rb"
require_relative "../../src/controllers/game_controller.rb"
require_relative "../../src/models/game_board.rb"
require_relative "../../src/models/position.rb"
require_relative "../../src/models/ship.rb"

# The ship coordinates for p1, p2
SHIPS_P1 = "#{__dir__}/inputs/correct_ships_p1.txt"
SHIPS_P2 = "#{__dir__}/inputs/correct_ships_p2.txt"

# The attack coordinates against p1, p2
ATTACK_P1 = "#{__dir__}/inputs/correct_strat_p1.txt"
ATTACK_P2 = "#{__dir__}/inputs/correct_strat_p2.txt"

# The perfect attack coordinates against p1, p2
PERF_ATK_P1 = "#{__dir__}/inputs/perfect_strat_p1.txt"
PERF_ATK_P2 = "#{__dir__}/inputs/perfect_strat_p2.txt"

# A bad ships file
BAD_SHIPS = "#{__dir__}/inputs/bad_ships.txt"

class PublicTests < MiniTest::Test
    def setup
        @p1_ships = []
        @p1_perf_atk = []
        @p2_ships = []
        @p2_perf_atk = []
        for i, size in [1,2,3,4].zip([4,5,3,2])
            pos0 = Position.new(i, i)
            pos1 = Position.new(i + 4, i + 4)
            @p1_ships << Ship.new(pos0, "Right", size)
            @p2_ships << Ship.new(pos1, "Right", size)
            for j in 0..(size - 1)
                @p2_perf_atk << Position.new(i, i + j)
                @p1_perf_atk << Position.new(i + 4, i + j + 4)
            end
        end
    end

    def test_public_gameboard_1
        test_board = GameBoard.new 10, 10

        # Property: A ship can be added in the bounds on an empty game_board 
        sngl_test_ret = test_board.add_ship(@p1_ships[0])
        assert(sngl_test_ret, "Ship in bounds should be added without error")
        for shp in @p1_ships[1..] 
            add_shp_ret = test_board.add_ship(shp)
            assert(add_shp_ret, "A valid ship was not added")
        end

        # Property: A ship will be hit if attacked
        for i in @p2_perf_atk
            assert(test_board.attack_pos(i), "Attack that should hit did not")
        end

        # Property: Nothing will change for a miss
        refute(test_board.attack_pos(Position.new(2, 1)), "Attack should have missed but hit")
    end

    def test_public_gameboard_2
        # Property: (add a ship & attack the length of the ship) => no. of attacks on the ship == nm_successful_attacks
        test_board = GameBoard.new(10, 10)
        for shp in @p2_ships
            add_shp_ret = test_board.add_ship(shp)
            assert(add_shp_ret, "A valid ship was not added")
        end
        refute(test_board.all_sunk?, "There is atleast one ship standing, but board says they're sunk")
        for i in @p1_perf_atk
            refute(test_board.all_sunk?, "All the ships have not sunk but board thinks they have")
            assert(test_board.attack_pos(i), "Attack that should hit did not")
        end
        assert(test_board.all_sunk?, "All the ships have sunk but board thinks they have not")
        assert_equal(@p1_perf_atk.length, test_board.num_successful_attacks, "The successful attacks must be the same as the number of ship slots")
    end

    def test_public_test_controller_1
        # This test just reads a correct file 
        # and performs some tests to check if 
        # The file was read correctly

        # Property: Correct files, does not yield errors
        assert(read_ships_file(SHIPS_P1), "#{SHIPS_P1} Should read correctly")
        assert(read_ships_file(SHIPS_P2), "#{SHIPS_P2} Should read correctly")
        assert(read_attacks_file(PERF_ATK_P1), "#{PERF_ATK_P1} Should read correctly")
        assert(read_attacks_file(PERF_ATK_P1), "#{PERF_ATK_P1} Should read correctly")

        game = GameController.new(2)
        p1_brd = game.load_ships(SHIPS_P1, 1)
        p1_atk = game.load_attacks(PERF_ATK_P1, 1)
        p2_brd = game.load_ships(SHIPS_P2, 2)
        p2_atk = game.load_attacks(PERF_ATK_P2, 1)

        pos0 = Position.new(2,1)
        pos1 = Position.new(2,2)
        pos2 = Position.new(2,3)
        pos3 = Position.new(2,4)

        # Property: A structure read from a valid file and has the ships attacked 
        #           will register the attack and return the values according to guidelines
        ret = p1_brd.attack_pos(pos1)
        ret = p1_brd.attack_pos(pos2) && ret
        ret = p1_brd.attack_pos(pos3) && ret

        p1_brd.attack_pos(pos0)
        assert(ret, "A boat is expected to be attacked but is not")
        assert_equal(3, p1_brd.num_successful_attacks, "The number of hits needs to be correct")
    end

    def test_public_test_controller_2
        # This is a rudimentary test to check if the 
        # Guide lines mentioned
        assert(read_ships_file(SHIPS_P1), "#{SHIPS_P1} Should read correctly")
        assert(read_ships_file(SHIPS_P2), "#{SHIPS_P2} Should read correctly")
        assert(read_attacks_file(ATTACK_P1 ), "#{ATTACK_P1} Should read correctly")
        assert(read_attacks_file(PERF_ATK_P2), "#{PERF_ATK_P2} Should read correctly")

        board_p1 = read_ships_file(SHIPS_P1)
        board_p2 = read_ships_file(SHIPS_P2)

        p1_moves = read_attacks_file(PERF_ATK_P2)
        p2_moves = read_attacks_file(ATTACK_P1)

        board_p2.attack_pos(p1_moves[0])

        for i in 1..([p1_moves.length, p2_moves.length].min - 1)
            refute(board_p1.all_sunk? || board_p2.all_sunk?, "The game is over too early")
            board_p2.attack_pos(p1_moves[i])
            board_p1.attack_pos(p2_moves[i])
        end

        assert(board_p2.all_sunk?, "P1 should have sunk all P2 Boats")
        refute(board_p1.all_sunk?, "P2 should not have sunk all P1 Boats")
    end

    def test_public_test_failure
        refute(read_ships_file(BAD_SHIPS), "#{BAD_SHIPS} Should Not read correctly")
    end
end

