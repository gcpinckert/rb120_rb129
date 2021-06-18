# Use modules to mix in generic, but not hierarchal behaviors
module Swimmable
  def swim
    puts "I'm swimming!"
  end
end

# Animal is a generic superclass containing basic behavior for ALL animals
class Animal
  # method takes no arguments, so subclass must invoke with super()
  def initialize
  end
end

# Pet is a subclass of Animal, but a superclass of GoodDog and Cat
class Pet < Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "Hello!"
  end
end

class Fish < Animal
  # mix the Swimmable module in with the Fish class, because Fish swim
  include Swimmable
end

# Subclass GoodDog inherits all methods from Animal & Pet
class GoodDog < Pet
  def initialize(color)
    # super invokes initialize method from Pet superclass
    # because it is called with no () or arguments, it passes the argument
    # assigned to parameter color to the Pet#initialize method
    super
    @color = color
  end

  # but methods defined within the class override inherited methods of the
  # same name
  def speak
    "#{self.name} says arf!"
  end

  # mix the Swimmable module in with the GoodDog class, because dogs swim
  include Swimmable
end

# Subclass Cat inherits all methods from Animal & Pet
# but does not get methods from Swimmable module, because cats don't swim
class Cat < Pet
  def initialize(temperament, name)
    # super invokes initialize method from Pet superclass
    # because it is called with an argument, it forwards that argument along
    super(name)
    @temperament = temperament
  end
end

class Bear < Animal
  def initialize(action)
    # super called with () invokes the Animal superclass method with no arguments
    # if method in question takes no arguments, super must be called this way
    super()
    @action = action
  end
end

sparky = GoodDog.new("Sparky")
paws = Cat.new("cuddly", "Paws")

# ---------- INHERITED BEHAVIORS ----------
# both instances of Pet subclasses inherit the speak method
puts sparky.speak   # -> Sparky says arf!
  # GoodDog speak method overrides inherited method
puts paws.speak     # -> Hello!
  # There is no Cat speak method to override method from Animal superclass

# ---------- HOW SUPER FORWARDS ARGUMENTS ---------
bruno = GoodDog.new('brown')
p bruno     # -> <GoodDog:0x00005566cabde080 @name="brown", @color="brown">
# bruno here has @name 'brown' and @color 'brown' because the GoodDog
# initialize method is defined with a super call that automatically forwards
# the arguments passed to the method that called it to the superclass method

tabby = Cat.new("curious", "Tabby")
p tabby     # -> <Cat:0x000055884cd41820 @name="Tabby", @temperament="curious">
# tabby has an initialize definition that uses two arguments, and when super
# is called with `name` argument, that gets passed along and assigned to
# the @name instance variable when the Animal#initialize method is invoked

bear = Bear.new("run away!!")
p bear      # -> <Bear:0x00005646cf8d4cf0 @action="run away!!">
# bear inherits the ScaryAnimal initialize method, which takes no arguments
# invoke it with super() and no arguments get passed

# ---------- MIXING IN MODULES ----------
# Fish class instances use inherited initialize method from Animal
nemo = Fish.new

# Fish and Dog instances can swim, but objects from other classes cannot
sparky.swim   # -> I'm swimming!
nemo.swim     # -> I'm swimming!
tabby.swim    # -> NoMethodError: undefined method `swim` for #<Cat:0x...etc
