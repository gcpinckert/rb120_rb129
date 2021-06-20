=begin
- Determine the lookup path when invoking bird1.color
- Only list the classes or modules that were checked by Ruby
=end

module Flyable
  def fly
    "I'm flying!"
  end
end

class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
  include Flyable
end

bird1 = Bird.new('Red')
bird1.color

p Bird.ancestors

# First Ruby will check the Bird class
# Then Ruby will check the Flyable module, which is included in the Bird Class
# Next Ruby will check the Animal class
# the #color getter method is defined on line 13 in the Animal class
# Ruby will invoke this method which will return the value assigned to @color
