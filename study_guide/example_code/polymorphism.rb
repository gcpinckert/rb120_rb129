# What is polymorphism in Ruby? How do we implement it in code?

# Polymorphism = the ability of objects of a different type to respond to the same interface
  # Same interface = the same method name (with same number of arguments)
  # Polymorphism via class inheritance
    # Using an inherited method
    # Overriding an inherited method for more specific implementation
  # Polymorphism via interface inheritance (modules)
  # Polymorphism via ducktyping

# All objects in Ruby inherit methods from Object and BasicObject class
# Therefore objects of a different type can respond to the same method call
['one', :two, 3, 4.0, ['five', 6]].each { |thing| puts thing.class }
  # => String
  # => Symbol
  # => Integer
  # => Float
  # => Array

# We use a module to mix in behaviors that apply to more than one class and are not easily modeled around a formal heirarchy
module Huntable
  def hunts
    puts "I hunt for prey"
  end
end

# We use a superclass to define general behaviors
class Animal
  # all animals eat food
  def eats
    puts "I eat food"
  end
end

# some animals have a specific diet
class Herbivore < Animal
  def eats
    puts "I eat plants"
  end
end

class Carnivore < Animal
  include Huntable
  
  def eats
    puts "I eat meat"
  end
end

# some animals do not have a specific diet
class Omnivore < Animal
  include Huntable
end

rabbit = Herbivore.new
lion = Carnivore.new
person = Omnivore.new

# all animal subtypes respond to `eats` appropriately
[rabbit, lion, person].each(&:eats)
  # => I eat plants
  # => I eat meat
  # => I eat food

# behaviors that apply to multiple unrelated classes can be mixed in with a module
# ruby's answer to multiple inheritance
lion.hunts      # => I hunt for prey
person.hunts    # => I hunt for prey
# rabbit.hunts  # => NoMethodError

# We can implement polymorphism through duck-typing when we informally group unrelated classes together by giving them the same behavior, even though they may not be related.

class SportsGame
  def play(attendees) # pass in an array of objects that attend a sports game
    attendees.each(&:attend)
  end
end

# define classes for each type of object that attends the sports game
class Athlete
  def attend
    puts "Shoots! Scores!"
  end
end

class Fan
  def attend
    puts "Go team go!"
  end
end

class Coach
  def attend
    puts "Hustle! Hustle!"
  end
end

class Cheerleader
  def attend
    puts "Ra! Ra! Yaaaay!"
  end
end

SportsGame.new.play([Athlete.new, Fan.new, Coach.new, Cheerleader.new])
# all objects respond to same `play` interface so are informally "types" together

# real world example: anything that can be iterated over can be considered a loosely typed collection
[1, 2, 3].each { |num| puts num }
{one: 1, two: 2, three: 3}.each { |word, num| puts "#{word} #{num}" }
