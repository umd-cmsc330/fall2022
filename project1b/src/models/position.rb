# ===========================================
# =====DON'T modify the following code=======
# ===========================================


class Position
    # @row is an `Integer`
    # @column is an `Integer`
    attr_reader :row, :column

    def initialize(row, column)
        @row = row
        @column = column
    end

    def to_s
        "(#{row}, #{column})"
    end
end
