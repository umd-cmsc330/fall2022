# ===========================================
# =====DON'T modify the following code=======
# ===========================================

class Ship
    # @start_position is a `Position`
    # @orientation is one of following `String`s
    #  - "Up" | "Down" | "Left" | "Right"
    # @size is an `Integer`
    attr_reader :start_position, :orientation, :size

    def initialize(start_position, orientation, size)
        @start_position = start_position
        @orientation = orientation
        @size = size
    end

    def to_s
        "Ship: #{@start_position}, #{orientation}, #{@size}"
    end
end
