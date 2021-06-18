module Walkable
  def walk
    "I'm walking"
  end
end

module Swimmable
  def swim
    "I'm swimming"
  end
end

module Climbable
  def climb
    "I'm climbing"
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak"
  end
end

class GoodDog < Animal
  include Swimmable
  include Climbable
end

# See the method lookup path with the ancestors class method
puts '---Animal Method Lookup---'
puts Animal.ancestors
  # -> ---Animal method lookup---
  # -> Animal (Ruby looks for the method here first)
  # -> Walkable
  # -> Object
  # -> Kernel
  # -> BasicObject

fido = Animal.new
puts fido.speak
  # -> I'm an animal, and I speak
  # the speak method is found in the Animal class, then Ruby stops looking

puts fido.walk
  # -> I'm walking
  # Ruby checks Animal for a walk method, doesn't find one
  # next it checks the walkable module, finds walk method, stops looking

# puts fido.swim
  # -> NoMethodError: undefined method 'swim' for #<Animal:0x...etc
  # The Swimmable module is not mixed in to Animal so is not available to fido

# The order in which we include modules in a class is important
puts "---GoodDog Method Lookup---"
puts GoodDog.ancestors
  # -> ---GoodDog method lookup---
  # -> GoodDog
  # -> Climbable (Ruby looks through last included method first)
  # -> Swimmable
  # -> Animal
  # -> Walkable (Modules mixed into superclass are inherited by subclasses)
  # -> Object
  # -> Kernel
  # -> BasicObject