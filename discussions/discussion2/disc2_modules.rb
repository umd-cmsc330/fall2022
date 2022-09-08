module WingedAnimal
    def fly
        puts 'Hello, I am something that can fly!'
    end
end

module AquaticAnimal
    def swim
        puts 'Hello, I am something that can swim!'
    end
end

module LandAnimalWrong
    def walk
        puts 'Hello, I am something that cannot walk!'
    end
end

module LandAnimal
    def walk
        puts 'Hello, I am something that can walk!'
    end
end

class Puffin
    include WingedAnimal
    include AquaticAnimal
    include LandAnimalWrong
    include LandAnimal 
end

class Bear
    include LandAnimalWrong
    include LandAnimal
end

class Bat
    include WingedAnimal
end

class Fish
    include AquaticAnimal
end

class Turtle
    include AquaticAnimal
    include LandAnimalWrong
    include LandAnimal
end

puffer = Puffin.new
puts 'Puffin activities:'
puffer.fly
puffer.swim
puffer.walk
polar = Bear.new
puts 'Bear activities:'
polar.walk
nightwing = Bat.new
puts 'Bat activities:'
nightwing.fly
finn = Fish.new
puts 'Fish activities:'
finn.swim
testudo = Turtle.new
puts 'Turtle activities:'
testudo.swim
testudo.walk