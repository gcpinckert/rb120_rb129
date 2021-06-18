=begin
- Add two methods:
  - ::generic_greeting which prints a greeting relevant to the class
  - #personal_greeting which prints a greeting relevant to the object
=end

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end

  def personal_greeting
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting
