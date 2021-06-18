=begin
- Change the given code from using instance variables and use a getter method
=end

class Cat
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
