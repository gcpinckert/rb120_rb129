=begin
- Using the code from 05.rb
- Move the greeting from #initialize into a new instance method #greet
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
  # -> Hello! My name is Sophie!
  