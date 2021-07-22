# SPOT Session 7-22-21 - Lucas

## Sample Interview Problem

```ruby
module Flightable  
  def fly
    puts "I am a #{@name}, I am a #{self.class} and I can fly!"
  end
end

class Superhero
  include Flightable 
  
  attr_accessor :ability
  
  def self.fight_crime
    puts "I am #{self}"
    self.new("coding skills").announce_ability
  end
  
  def initialize(name)
    @name = name
  end
  
  def announce_ability
    puts "I fight crime with my #{ability} ability!"
  end
  
  def self.to_s
    "superman"
  end
end

class LSMan < Superhero 
  def self.to_s
    "LSMan"
  end
  
  def initialize(ability)
    @ability = ability
  end
end

class Ability
  attr_reader :description

  def initialize(description)
    @description = description
  end
end

superman = Superhero.new('Superman')
superman.fly # => I am Superman, I am a superhero, and I can fly!
LSMan.fight_crime 
# => I am LSMan!
# => I fight crime with my coding skills ability!
```

## Code Spike

- long question at the end of the assessment
- know how to pull the nouns and verbs
- show you understand the relationships between classes and objects
- show you understand the difference between interface and class inheritance

## Fake Operators

- You don't need to memorize, but be able to pull up the graph

## Practice Question

```ruby
class BenjaminButton
  attr_accessor :actual_age, :appearance_age
  
  def initialize
    @actual_age = 0
    @appearance_age = 100
  end
  
  def get_older
    self.actual_age += 1
    self.appearance_age -= 1
  end
  
  def look_younger
  end
  
  def die
    self.actual_age = 100
    self.appearance_age = 0
  end
  
  def actual_age=(age)
    @actual_age = age.to_i
  end
  
  #def actual_age 
  #  0
  #end
  
#  # def appearance_age
#   #  100
#   end
end

benjamin = BenjaminButton.new
p benjamin.actual_age # => 0
p benjamin.appearance_age # => 100

benjamin.actual_age = '1'

benjamin.get_older
p benjamin.actual_age # => 2
p benjamin.appearance_age # => 99

benjamin.die
p benjamin.actual_age # => 100
p benjamin.appearance_age # => 0
```

The benefit to using a custom defined setter is that we can add our own custom functionality. Note that writing a custom setter method will _override_ any `attr_*` methods that you have defined.

## Encapsulation

You can't call custom defined methods on random objects, you have to access them through the instance object that is created from your custom class.

```ruby
class Person
  def speak
    'I am a person!'
  end
end

'hello'.speak       # => NoMethodError
```

## Polymorphism

Good simple example:

```ruby
class Person
  def move
    puts "I walk"
  end
end

class Car
 def move
  puts "I drive"
 end
end

someguy = Person.new
somecar = Car.new
[someguy, somecar].each { |object| object.move}
```

## Namespacing

```ruby
module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end
  
  class Cat
    def say_name(name)
      p "#{name}"
    end 
  end 
end 

#instantiate a dog object
p buddy = Mammal::Dog.new

# allows us to have classes of the same name
module History
  class Teacher;end
end 

module English
  class Teacher;end
end
```

Above we define the two `Teacher` classes in namespace modules `History` and `English`. This gives us the ability to have two classes of the same name which might exhibit different behaviors.
