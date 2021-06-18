=begin
- Using the given code, replace manual method defs with Ruby shorthand
=end

class Cat
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
kitty.name = 'Luna'
kitty.greet