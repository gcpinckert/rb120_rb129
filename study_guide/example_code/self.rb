# What is `self`? Demonstrate how it is used.

# self is a special keyword in Ruby that acts a little bit like a variable
# always references what level of the codebase we're currently on
# way to be explicit with Ruby about our intentions

# What is self?

module Showable
  self              # references the module itself

  def show
    self            # references the calling object (an instance)
  end

  def self.show
    self            # references the calling object (the module)
  end
end

class Mirror
  include Showable

  self              # references the class itself

  def reflect
    self            # references the calling object (an instance)
  end
  
  def self.reflect
    self            # references the calling object (the class)
  end
end

a = Mirror.new

puts "Within an instance method:"
p a.reflect         # => #<Mirror:0x0000561bd1942cd8>
p a.show            # => #<Mirror:0x0000561bd1942cd8>
puts
puts "Within a class or module method:"
p Mirror.reflect    # => Mirror (the class that calls it)
p Showable.show     # => Showable (the module that calls it)
puts
puts "Outside any 'containers':"
p self              # => main
puts

# self use cases:
# calling setter methods within a class
# differentiate them from local variable assignment

class ContactCard
  attr_accessor :name, :address

  def initialize(name, address)
    @name = name
    @address = address
  end

  def move(new_house)
    self.address = (new_house)
  end
end

bob = ContactCard.new('Bob', '123 Street St')
puts bob.address
bob.move('456 Avenue Blvd')
puts bob.address    # (without self.address in #move) => 123 Street St
                    # (with self.address in #move) => 456 Avenue Blvd
puts

# defining a class method
# self tells Ruby we want the calling object to be the class

class Dog
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.name       # self references the class Dog
    "canis lupis familiaris"
  end
end

fido = Dog.new('Fido')
puts fido.name        # => Fido
puts Dog.name         # => canis lupis familiaris
puts

# disambiguate from keywords
module Explainable
  def explain
    # below we use self to show we are calling the #class method
    puts "My name is #{name} and I am a #{self.class}."
  end
end

class Being
  include Explainable

  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class Robot < Being; end
class Human < Being; end
class Alien < Being; end

marvin = Robot.new('Marvin')
arthur = Human.new('Arthur Dent')
ford = Alien.new('Ford Prefect')

marvin.explain
arthur.explain
ford.explain