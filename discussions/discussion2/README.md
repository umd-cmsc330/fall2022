# Discussion 2 - Friday, September 9<sup>nd</sup>
 

## Introduction

Last week, we reviewed fundamental OOP concepts in Ruby and introduced the concept of regular expressions. Today, we will be building on both of these concepts. In particular, we will explore modules, mixins and file I/O in Ruby.

## Part 1: `Animals`

We want to create classes that represent different animals, namely a `Bat`, `Puffin`, `Turtle`, `Fish` and `Bear`. We will describe attributes of these animals using modules and mixing in those modules (mixins).

Modules are used to group together methods that a class can inherit: you should think of them as being in a "has a" relationship. A class that includes a module will have all of the methods defined in the module. 

We will group animals based on three attributes: whether they are a `WingedAnimal`, `LandAnimal`, or an `AquaticAnimal`.

```ruby
module WingedAnimal
    def fly
        puts 'Hello, I am something that can fly!'
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
```

Notice that we have a `LandAnimalWrong` module with the same `walk` method as `LandAnimal`; we will use this to explore the role of precedence when mixing in modules.


Now, we can define our animals as follows:

```ruby
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
```

Let's see what happens when we instantiate these animals and call the methods we included:

```ruby
puffer = Puffin.new
puts 'Puffin activities:'
puffer.fly
puffer.swim
puffer.walk     # prints "Hello, I am something that can walk!"
polar = Bear.new
puts 'Bear activities:'
polar.walk     # prints "Hello, I am something that can walk!"
nightwing = Bat.new
puts 'Bat activities:'
nightwing.fly
finn = Fish.new
puts 'Fish activities:'
finn.swim
testudo = Turtle.new
puts 'Turtle activities:'
testudo.swim
testudo.walk     # prints "Hello, I am something that can walk!"
```

Observe that we always print the correct "Hello, I am something that can walk!" message. This is because the class will use the method as defined in the most recent module that was mixed in. As discussed in class, if a class calls a method `m`, we first look for method `m` in the class. If it's not in the class, we look in the mixins: if multiple mixins included, we start in latest mixin, then try the earlier (shadowed) mixins. In the exampled outlined, the `LandAnimalWrong` mixin was shadowed by the `LandAnimal` mixin, so the `walk` method works as expected.

## Part 2: `File I/O`

The aim of this part is to learn how to read/write files in Ruby. We use the [File](https://ruby-doc.org/core-2.5.0/File.html) class and codeblocks to perform reads and writes to the files. Let's start with a little basics of codeblocks.

### Codeblocks

Codeblocks are special methods that are invoked by the method to perform desired operations. Codeblocks are passed in as arguments to other methods. They are anonymous methods, i.e. you define them when you pass them as argument and their scope is limited to that method. Codeblocks are helpful especially in iterations.

```ruby
a = [1, 2, 3, 4, 5]
a.each { |x| puts x }       # will print each elements of a, notice the structure of a codeblock
a.each do |x| puts x end    # analogous syntax with do...end
```

You can use codeblocks with numbers and strings as well.

```ruby
5.upto(10) { |x| puts x }                       # will print from 5 to 10
"Go Terps!".split(",").each { |x| puts x }      # will print "Go", "Terps!"
```

Now that we know about codeblocks, we can use them with file I/O to make our lives easier.

The [File](https://ruby-doc.org/core-2.5.0/File.html) class offers numerous methods for file operations. We will use `open` popularly. There are other methods like `chmod` (analogoud to `chmod` in shell from 216).

The syntax of opening a file is as below.

```ruby
File.open("file_name.extention", "mode") do |file|
    # content of the code block
end

file = File.open("file_name.extension", "mode")
# process file here
file.close
```

We give `open` three parameters: the filename, the mode (by default, it is read_only mode), and the codeblock with one parameter. We can give `open` two parameters and it will return the `File` object that we can work with. In this, it is important to close the file explicitly. The file is automatically closed in the first example after the codeblock is executed. 

### File I/O

Now that we have our file open, we can read from it or write to it based on the mode. Let's see examples of reading from the file.

* Reading all lines at once

We can read all lines at once using `file.readlines`. This will return an array of all lines (handled as strings) in the file.

```ruby
File.open("readlines.txt", "r") do |file|
    file.readlines.each { |line| puts line }    # will print all lines from the file
end
```

* Reading one line at a time

We can also read one line at a time using `file.readline`. The method reads one line and moves to next line to be read. **Be careful about the pointer when using `readline`.** This method can be useful when you want to read selected number of lines from the file.

```ruby
File.open("readlines.txt", "r") do |file|
    puts file.readline                      # will print the first line
    
    1.upto(3) { |x| puts file.readline }    # will print next three lines 
end
```

Now that we have access to the content of the file, we can perform string operations on them to process as required.

```ruby
lines_array = Array.new(10)
File.open("readlines.txt", "r") do |file|
    file.readlines.each do |line|
        if line =~ /^This is line (\d+)$/
            lines_array[$1.to_i] = line
        end
    end
end

puts lines_array
```

And with this, we have basics for reading from a file and processing its content.
