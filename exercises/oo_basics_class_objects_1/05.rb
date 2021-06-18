=begin
- Using code from 04.rb:
- Add a parameter to #initialize that provides a name for the Cat object
- Use an instance variable to print a greeting with that name
- Get rid of 'I'm a cat!' output
=end

class Cat
  attr_accessor :name

  def initialize(name)
    self.name = name
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
