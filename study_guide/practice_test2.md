# Practice Test 2

---

1

_What is the difference between instance methods and class methods?_

---

2

_What are collaborator objects, and what is the purpose of using them in OOP? Give an example of how we would work with one._

---

3

_How and why would we implement a fake operator in a custom class? Give an example._

---

4

_What are the use cases for `self` in Ruby, and how does `self` change based on the scope it is used in? Provide examples._

---

5

```ruby
class Person
  def initialize(n)
    @name = n
  end
  
  def get_name
    @name
  end
end

bob = Person.new('bob')
joe = Person.new('joe')

puts bob.inspect # => #<Person:0x000055e79be5dea8 @name="bob">
puts joe.inspect # => #<Person:0x000055e79be5de58 @name="joe">

p bob.get_name # => "bob"
```

_What does the above code demonstrate about how instance variables are scoped?_

---

6

_How do class inheritance and mixing in modules affect instance variable scope? Give an example._

---

7

_How does encapsulation relate to the public interface of a class?_

---

8

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky
```

_What is output and why? How could we output a message of our choice instead?_

_How is the output above different than the output of the code below, and why?_

```ruby
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    @name = n
    @age  = a * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
p sparky
```

---

9

_When does accidental method overriding occur, and why? Give an example._

---

10

_How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers._

---

11

_Describe the distinction between modules and classes._

---

12

_What is polymorphism and how can we implement polymorphism in Ruby? Provide examples._

---

13

_What is encapsulation, and why is it important in Ruby? Give an example._

---

14

```ruby
module Walkable
  def walk
    "#{name} #{gait} forward"
  end
end

class Person
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Walkable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

mike = Person.new("Mike")
p mike.walk

kitty = Cat.new("Kitty")
p kitty.walk
```

_What is returned/output in the code? Why did it make more sense to use a module as a mixin vs. defining a parent class and using class inheritance?_

---

15

_What is Object Oriented Programming, and why was it created? What are the benefits of OOP, and examples of problems it solves?_

---

16

_What is the relationship between classes and objects in Ruby?_

---

17

_When should we use class inheritance vs. interface inheritance?_

---

18

```ruby
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new
```

_If we use `==` to compare the individual `Cat` objects in the code above, will the return value be `true`? Why or why not? What does this demonstrate about classes and objects in Ruby, as well as the `==` method?_

---

19

```ruby
class Thing
end

class AnotherThing < Thing
end

class SomethingElse < AnotherThing
end
```

_Describe the inheritance structure in the code above, and identify all the superclasses._

---

20

```ruby
module Flight
  def fly; end
end

module Aquatic
  def swim; end
end

module Migratory
  def migrate; end
end

class Animal
end

class Bird < Animal
end

class Penguin < Bird
  include Aquatic
  include Migratory
end

pingu = Penguin.new
pingu.fly
```

_What is the method lookup path that Ruby will use as a result of the call to the `fly` method? Explain how we can verify this._

---
