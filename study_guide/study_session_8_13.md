# Study Session 8/13/2021

## How do class inheritance and mixing in modules affect instance variable scope?

```ruby
module Teachable
  def teach
    @teaching = true
  end
end

class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class TeachingAssistant < Person
  include Teachable

  def initialize(name)
    @name = name
  end
  
  def is_teaching?
    "I am teaching a course" if @teaching
  end
end

bob = Person.new("Robert", 48)

kyle = TeachingAssistant.new("Kyle")

# p bob

# p kyle
kyle.teach

p kyle.is_teaching?
```

## How do class inheritance and mixing in modules affect instance variable scope? Give an example

```ruby
class Pet
  @@furry = true

  attr_reader :name, :cute
  
  def initialize(name)
    @name = name
  end
  
  def make_cute
    @cute = true
  end
  
  def furry?
    @@furry
  end
  
  def self.furry
    @@furry
  end
end

class Dog < Pet; end

class Cat < Pet 
  def hairless_cat
    @@furry = false
  end
end

fido = Dog.new('Fido')
snoopy = Dog.new('Snoopy')
lassie = Dog.new("Lassie")

p fido
p snoopy
p lassie

fido.name
snoopy.name
lassie.name

felix = Cat.new('Felix')
felix.hairless_cat
p felix.furry?
p Cat.furry
```

## How does encapsulation relate to the public interface of a class?

```ruby
# What is encapsulations?
# What is a public interface (vs private implementation)?
# How are they related

class Person
  # attr_reader :name
  
  def initialize(name, number)
    @name = name
    @number = number
  end
  
  def phonenumber
    "XXX-#{number[-4, 4]}"
  end
  
  private
  
  attr_reader :number
  
end

bob = Person.new('Bob', '867-5309')
p bob

# p bob.name
p bob.instance_variable_get("@name")
p bob.phonenumber

# https://ruby-doc.org/core-3.0.2/Object.html#method-i-instance_variable_get
```

## What are modules? When is it appropriate to use them?

```ruby
=begin
Modules are containers for behaviors and constants. 

Modules used as mixins or interface inheritance

Modules used for namespacing

Modules can be used as containers for module methods
=end

module Flyable
  def fly
    "I can fly"
  end
end

class Being
end

class Plant < Being
end

class Animal < Being
end

class Bird < Animal
end

class Mammal < Animal
end

class Bat < Mammal
  include Flyable
end

class Penguin < Bird
end

class Pigeon < Bird
  include Flyable
end

module Course
  module People
    class Faculty
    end
    
    class TeachingAssistant
    end
    
  end
  
  module Departments
    class ReligiousStudies
    end
    
    class Biology
    end
  end
end

Course::People::Faculty.new

module OddMethods
  def self.weird_method
    "This is a weird method"
  end
end

p OddMethods.weird_method
p OddMethods::weird_method
```

## Practice Problem 1: Students

Problem:

```ruby
# Given the following classes, implement the necessary methods to get the expected output.

class DataBase
  def initialize
    @things = []
  end
end

class Student
  def initialize(name, id)
    @name = name
    @id = id
  end
end

jill1 = Student.new('Jill', 12345)
jill2 = Student.new('Jill', 67890)
jill3 = Student.new('Jill', 12345)

jill1 == jill2              # false
jill1 == jill3              # true

kids = DataBase.new

kids << jill1
kids << jill2
kids << jill3               # => That student is already in the database

kids.show_things
  # => A Student: Jill
  # => A Student: Jill
```

Possible solution:

```ruby
class DataBase
  attr_reader :things
  
  def initialize
    @things = []
  end
  
  def <<(thing)
    if things.include?(thing)
      puts "That #{thing.class.to_s.downcase} is already in the database"
    else
      things << thing
    end
  end
  
  def show_things
    things.each { |thing| puts "A #{thing.class}: #{thing.name}" }
  end
end

class Student
  attr_reader :name, :id
  
  def initialize(name, id)
    @name = name
    @id = id
  end
  
  def ==(other)
    id == other.id
  end
  
  def to_s
    name
  end
end

jill1 = Student.new('Jill', 12345)
jill2 = Student.new('Jill', 67890)
jill3 = Student.new('Jill', 12345)

p jill1 == jill2         # => false
p jill1 == jill3         # =>  true

kids = DataBase.new

kids << jill1
kids << jill2
kids << jill3            # => That student is already in the database

kids.show_things
  # => A Student: Jill
  # => A Student: Jill
```
