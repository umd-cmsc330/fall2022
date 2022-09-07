class Rectangle
    @@area = {}

    def initialize(length, width)
        @length = length
        @width = width
        if length*width in @@area.keys then
            @@area[length*width] += 1 
        else
            @@area[length*width] = 1
        end
    end

    def getArea()
        return @length*@width
    end

    def self.getNumRectangles(n)
        # iterate through hash, if key is < n, then add v to the counter
    end
end