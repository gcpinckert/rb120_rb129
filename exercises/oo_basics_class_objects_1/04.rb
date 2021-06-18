=begin
- Using code from 03.rb
- add an #initialize method that prints 'I'm a cat!' when a new Cat is created
=end

class Cat
  def initialize
    puts "I'm a cat!"
  end
end

kitty = Cat.new
  # -> I'm a cat!
  