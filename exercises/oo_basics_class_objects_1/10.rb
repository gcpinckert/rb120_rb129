=begin
- Using the given code, create a module named Walkable
- It should contain a method #walk
- #walk should print "Let's go for a walk!" when invoked
- Include Walkable in Cat
- Invoke #walk on kitty
=end

module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end

class Cat
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
  # -> Hello! My name is Sophie!
kitty.walk
  # -> Let's go for a walk!
