=begin
- Print "Hello! I'm a cat!" when #generic_greeting is invoked
=end

class Cat
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
end

Cat.generic_greeting
  # -> Hello! I'm a cat!

# Further Exploration
kitty = Cat.new

kitty.class.generic_greeting
  # -> Hello! I'm a cat!
=begin
The above code words because we are chaining the class method ::generic_greeting
onto the value returned by the Object#class method (an instance method), and
that value happens to be the Class of the calling object. In this case, it is
the Cat class, which then calls ::generic_greeting
=end
