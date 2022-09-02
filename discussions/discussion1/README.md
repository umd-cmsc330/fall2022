# Discussion 1 - Friday, September 2<sup>nd</sup>

## Introduction

We created a Ruby exercise which has you work with some of the features you learned about in class. The focus here is on the problem solving process itself, and particularly the following steps: 


1. Problem Understanding: can you break down a set of instructions into manageable tasks
2. Algorithmic Planning: can you develop pseudocode or a sketch of the code 
3. Implementation and information retrieval: can you implement the solution, and more importantly, find resources to help you (documentation) when stuck

We'll walk you through this example, but the concepts covered will be important for future projects. 

## Instructions

We will be implementing a simple class in Ruby to illustrate OOP concepts. In the class, we will implement a few simple methods, class fields as well as introdocuing the concept of code blocks.

## Part 1: `Rectangle Class`

A `Rectangle` represents a rectangle shape.  The methods below will be implemented in the `Rectangle` class in [disc1.rb](src/disc1.rb).

#### `initialize(length, width)`

- **Type**: `(Float, Float) -> _`
- **Description**: Given a length and width for the rectangle, store them in the `Rectangle` object.  You should perform any initialization steps for the `Rectangle` instance here. The return value of this function does not matter. Note that we must keep track of the number of `Rectangle` objects that have been instantiated. 
- **Examples**:
  ```ruby
  square = Rectangle.new(5, 5)
  rectangle = Rectangle.new(2, 3)
  ```

#### `getArea()`

- **Type**: `_ -> Float`
- **Description**: Return the area of a `Rectangle`
- **Examples**:
  ```ruby
  square = Rectangle.new(5, 5)
  rectangle = Rectangle.new(2, 3)
  square.getArea()              # Returns 25
  rectangle.getArea()           # Returns 6
  ```


#### `self.getNumRectangles(n)`

- **Type**: `(Integer) -> Integer`
- **Description**: Return the number of `Rectangles`s whose area is less than n.  Hint: you should use a static data structure to keep track of this.
- **Examples**:
  ```ruby
  Rectangle.getNumRectangles(20)        # Returns 0
  square = Rectangle.new(5, 5)
  rectangle = Rectangle.new(2, 3)
  Rectangle.getNumRectangles(20)        # Returns 1
  Rectangle.getNumRectangles(30)        # Returns 2
  ```
  
## Part 2: `Regular Expressions`

Regular expressions are patterns that are used to match strings and extract information. They are internally implemented using finite state automata, which will be covered later in the class. For now, we will focus on Regular Expressions in Ruby.

The simplest Regex matches a string literal. 

```ruby
p = /pattern/       # will match any string that contains "pattern" as a substring
if p =~ "pattern" then
    puts "Matched"
else
    puts "Not Matched"
end
```

However, Regex is more powerful; it can be used to describe the following additional patterns:

- Ranges: `/[a-z]/`, `/[c-k]/`, `/[A-Z]/`, `/[0-9]/`
We use these ranges, also known as character classes, to accept characters within a specified range (inclusive).
- Or (Union): `/a|b|c/`
We use this to accept one character from the given choices.
- Sets: `/[abc]/`, `/[34567]/`
The bracket notation is shorthand for the union operation on the characters within the brackets; 
- Meta Characters: `/\d/`, `/\D/`, `/\s/`
We use these characters to match on any of a particular type of pattern.
- Wildcard: `.`
We use this to match on any character. Note: to use a literal `.`, we must escape it, i.e. `/\./`.
- Beginning of pattern: `/^hello/`
Here, the string must begin with "h".
- End of pattern: `/hello$/`
Here, the string must end with "o".
- Beginning and end of pattern: `/^abc$/`
We will use this to match exactly to patterns, so any string matching the above Regex must start with an "a" and end with a "c," so only the string "abc" will be matched.
- Repetitions: `/a*/`, `/a+/`, `/a?/`, `/a{3}/`, `/a{4,6}/`, `/a{4,}/`, `/a{,4}/`
We use these to describe when a pattern is to be repeated. Note that the repetition only occurs on the character immediately preceding it; to repeat a whole pattern, use parentheses 
- Negation: `/[^a-z]/`, `/[^0-9]/`
We use these to exclude a range of characters.

Regular expressions in Ruby also have capture groups, which allow us to extract patterns from a string that are of interest. We can group a part of the Regex to be captured between parentheses and reference them using the syntax `$n`, where `n` is the index of the desired capture group. 

```ruby
p = /(\w) (\d) ([bcde])/            # If a string matches this regex, $1 will refer to anything matched by \w, and $2 will refer to anything matched by \d and so on.
```

```ruby
p1 = /([A-Z][a-z]+) ([0-9]{9})/     # Regex that matches on a student's first name, followed by a space, followed by a 9 digit UID.
p2 = /([A-Z]\w+) (\d{9})/            # Equivalent Regex to p1
s1 = "Dan 314159265"
if p1 =~ s1 then
    puts $1                         # Will print out the student's name
end

s2 = "Lightyear 123456789"
if p1 =~ s2 then
    puts $2.to_i                    # Will print out the student's UID as an integer i.e. 123456789.
end                                 # Notice how the backreferences are reset each time you do a match
```
