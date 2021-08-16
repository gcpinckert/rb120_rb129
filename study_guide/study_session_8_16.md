# Study Session 8/16/2021

```ruby
class Dice
  def roll
    rand(1..12)
  end
end

puts Dice.new.roll
```

## Describe the distinction between modules and classes

```ruby
# class can instantiate
# interface vs class inheritance

module Walkable
  def walk
    puts "I'm walking"
  end
end

class Person
  include Walkable
  
  def initialize(name)
    @name = name
  end
  
  def greet
    puts "Hello"
  end
end

class Mom; end

class Dad; end

class Child < Person
  def throw_tantrum
    puts "AAAAAAAAAAAAAAAAAAAAH"
  end
end

class Dog
  include Walkable
end

bobby = Child.new('Bobby')
bobby.greet
bobby.throw_tantrum
bobby.walk

Person.new('Bob').walk
Dog.new.walk
```

## How does encapsulation relate to the public interface of a class?

```ruby
# What is encapsulation
# What does that have to do with a public interface
# How is that different from private behaviors/data

class Person
  attr_reader :name
  
  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end
  
  def location
    "I live on #{address.split[1]} street."
  end
  
  def first_three
    "#{number[0..3]}"
  end
  
  private
  
  attr_reader :number, :address
end

bob = Person.new('Bob', '867-5309', '123 Street St')
p bob.name
p bob.location
p bob.first_three


bobs_name = "Bob"
bobs_location = "12345"

# Ruby incorporates encapsulation by creating objects
# Bob's name is created within the object Bob
# Show how data acts differently within an object vs as local variable
```

## What is the relationship between classes and objects in Ruby?

```ruby
# What is a class?
# What is an object?

class Barbarian
  
  def initialize(name)
    @name = name
  end
  
  def attack
    "attacks"
  end
end

conan = Barbarian.new("Conan")

sonya = Barbarian.new("Sonya")

p conan
p sonya

[conan, sonya].each do |character|
 p character.attack
end

p 'hello world'.is_a?(Integer)
p true.is_a?(TrueClass)
p Array.is_a?(Object)



p "string".class.ancestors

# current class, module, super class, OK BO
```

## What is self? Demonstrate how it is used

```ruby
class Mammal
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
  
  def change_name(new_name)
    self.name = new_name
  end
  
end


p mammal1 = Mammal.new("Mike")
p mammal1.change_name("Ginni")
p mammal1


# What is self?

class Mammal
  def greet
    p self
  end
end

Mammal.new.greet

# It has two major use cases
  # show calling setter methods
  # show defining class methods

# self is a keyword used in Ruby to be explicit about what we are referencing in our code structure, and what our intentions are regarding behavior
```

## What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one

```ruby
class Library
  attr_reader :books
  
  def initialize
    @books = []
  end
  
  def <<(book)
    books << book
  end
  
  def browse_books
    books.each do |book|
      puts "======"
      puts book
      puts
    end
  end
end

class Book
  def initialize(title, author)
    @title = title
    @author = author
  end
  
  def to_s
    "#{author.split[1]}, #{author.split[0]} : #{title}"
  end
  
  private
  
  attr_reader :title, :author
end

library = Library.new

library << Book.new('Great Expectations', 'Charles Dickens')
library << Book.new('The Dragon Reborn', 'Robert Jorden')
library << Book.new('The Left Hand of Darkness', 'Ursula K LeGuin')

library.browse_books

# What is the purpose.

# collaborator objects represent connections between actors in a program (associative relationship)

# Takes advantage of encapsulation
```

## What is the attr_accessor method, and why wouldn’t we want to just add attr_accessor methods for every instance variable in our class? Give an example

```ruby
# What is it?
# What does it do?
# When is it useful?
# When is it detrimental?

class Person
  attr_reader :address
  
  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end
  
  # def address
  #   # validate address format
  #   puts "This is not a valid address" if invalid_address? 
  #   @address = address
  
  def name
    @name.dup
  end
  
  def number
    "unlisted"
  end
    
end

bob = Person.new('Bob', '867-5309', '123 Street St')
puts "HAPPY BIRTHDAY #{bob.name.upcase!}"
p bob.name
p bob.number

# attr_accessor is a method call, and we pass symbols as arguments to show what we want the created getter/setter methods to be named
```

## What is super?

```ruby
# How do we use it?
# Pros and cons

class Animal
  def initialize
    # implementation pertaining to animals
  end
end

class Pet < Animal
  def initialize(name)
    super()
    @name = name
  end
  
  def speak
    "hello"
    # some really long implementation
  end
end

class Cat < Pet
  def initialize(name, personality)
    super(name)
    @personality = personality
  end
  
  def speak
    'meow ' + super + ' meow'
  end
end

class Dog < Pet
  def speak
    "woof woof " + super + " woof woof"
  end
end


puts Cat.new('felix', 'curious').speak
puts Dog.new('fido').speak



# Ruby provides us with the super keyword to call methods earlier in the method lookup path. When you call super from within a method, it searches the method lookup path for a method with the same name, then invokes it. Let's see a quick example of how this works:

# super is a keyword that _acts_ like a method
# self is a keyword that _acts_ like a method
```

## Practice Problem 1

```ruby
class Character
  #ommited for brevity
  
  # def war_scream
  #   "#{self.class} says "
  # end
end

class Fighter < Character
  # def war_scream
  #   super + "TO WAR!!!!!!!!!"
  # end
end

class Mage < Fighter
  # def war_scream
  #   " but we must stay level headed!"
  # end
end

class Bowman < Mage
  def war_scream
   super + super + "no problem I got this. to warr!"
  end
end

p Fighter.new.war_scream    # => Fighter says TO WAR!!!!!!!!!!!!
p Mage.new.war_scream       # => "but we must stay level headed!"
p Bowman.new.war_scream     # => " but we must stay level headed!" " but we must stay level headed!" "no problem I got this. to warr!"

p Bowman.ancestors
```

## Practice Problem 2

Problem:

```ruby
# Perform the implementations for each method to output as shown:

class BenjaminButton
  def initialize
  end
  
  def get_older
  end
  
  def look_younger
  end
  
  def die
  end
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

Possible Solution:

```ruby
# Perform the implementations for each method to output as shown:

class BenjaminButton
  attr_reader :actual_age, :appearance_age
  
  def initialize
    @actual_age = 0
    @appearance_age = 100
  end
  
  def get_older
    self.actual_age += 1
    look_younger
  end
  
  def look_younger
    self.appearance_age -= 1
  end
  
  def die
    self.actual_age = 100
    self.appearance_age = 0
  end
  
  def actual_age=(age)
    @actual_age = age.to_i
  end
  
  def appearance_age=(age)
    @appearance_age = age.to_i
  end
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
