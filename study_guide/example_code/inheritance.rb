# How does inheritance work in Ruby? When would inheritance be appropriate?

# Class Inheritance 
  # Superclasses and Subclasses
  # Inherited general behaviors
  # Overriding with more specific behaviors
# Interface Inheritance
  # Ruby's answer to multiple inheritance
  # Mixin Modules
  # has_a vs is_a

# All classes in Ruby are part of an inheritance chain
p String.ancestors
  # => [String, Comparable, Object, PP::ObjectMixin, Kernel, BasicObject]
p Integer.ancestors
  # => [Integer, Numeric, Comparable, Object, PP::ObjectMixin, Kernel, BasicObject]
p Array.ancestors
  # => [Array, Enumerable, Object, PP::ObjectMixin, Kernel, BasicObject]

# Inheritance allows classes to access methods that are defined higher up in the method lookup chain
# i.e. in the modules and classes returned by the ancestors method above

# we can put behaviors that need to be mixed into classes with no formal hierarchy in a module
module Trackable
  def track
    puts "Tracks the smell..."
  end
end

class Dog
  def speak
    puts "Woof!"
  end
end

class Poodle < Dog; end

class Collie < Dog
  include Trackable
end

class Beagle < Dog
  include Trackable
end

# all objects instantiated from the Dog subclasses can access the Dog#speak method

Poodle.new.speak
Collie.new.speak
Beagle.new.speak

# but we can concieve of certain subclasses that may need a more specific implementation

class GreatDane < Dog
  include Trackable
  
  # by defining a different implementation we can overide the general behavior
  def speak
    puts "WOOF WOOF"
  end
end

class Chihuahua < Dog
  def speak
    puts "yip! yip!"
  end
end

GreatDane.new.speak
Chihuahua.new.speak

# multiple unrelated classes may sometimes need access to the same method
Collie.new.track        # => Tracks the smell...
Beagle.new.track        # => Tracks the smell...
GreatDane.new.track     # => Tracks the smell...
# Poodle.new.track        # => NoMethodError

# generally if a class is a type of another class, we want to use class inheritance
# if we need to make a behavior (or set of behaviors) available widely 
# regardless of relationship, we use a module