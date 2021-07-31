# Short Practice Test

---

1

```ruby
class Animal
  def initialize(name)
    @name = name
  end

  def speak
    puts sound
  end

  def sound
    "#{@name} says "
  end
end

class Cow < Animal
  def sound
    super + "moooooooooooo!"
  end
end

daisy = Cow.new("Daisy")
daisy.speak
```

_What does this code output and why?_

---

2

```ruby
class Cat
  def initialize(name, coloring)
    @name = name
    @coloring = coloring
  end

  def purr; end

  def jump; end

  def sleep; end

  def eat; end
end

max = Cat.new("Max", "tabby")
molly = Cat.new("Molly", "gray")
```

_Do `molly` and `max` have the same states and behaviors in the code above? Explain why or why not, and what this demonstrates about objects in Ruby._

---

3

```ruby
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end
  
  def change_grade(new_grade)
    grade = new_grade
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade 
```

_In the above code snippet, we want to return `”A”`. What is actually returned and why? How could we adjust the code to produce the desired result?_

---

4

```ruby
class MeMyselfAndI
  self

  def self.me
    self
  end

  def myself
    self
  end
end

i = MeMyselfAndI.new
```

_What does each `self` refer to in the above code snippet?_

---

5

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
  end 
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

_Running the following code will not produce the output shown on the last line. Why not? What would we need to change, and what does this demonstrate about instance variables?_

---

6

```ruby
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

sir_gallant = Knight.new("Gallant")
p sir_gallant.name 
p sir_gallant.speak 
```

_What is output and returned, and why? What would we need to change so that the last line outputs `”Sir Gallant is speaking.”`?_

---

7

```ruby
class FarmAnimal
  def speak
    "#{self} says "
  end
end

class Sheep < FarmAnimal
  def speak
    super + "baa!"
  end
end

class Lamb < Sheep
  def speak
    super + "baaaaaaa!"
  end
end

class Cow < FarmAnimal
  def speak
    super + "mooooooo!"
  end
end

p Sheep.new.speak
p Lamb.new.speak
p Cow.new.speak 
```

_What is output and why?_

---

8

```ruby
class Person
  def initialize(name)
    @name = name
  end
end

class Cat
  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

sara = Person.new("Sara")
fluffy = Cat.new("Fluffy", sara)
```

_What are the collaborator objects in the above code snippet, and what makes them collaborator objects?_

---

9

```ruby
number = 42

case number
when 1          then 'first'
when 10, 20, 30 then 'second'
when 40..49     then 'third'
end
```

_What methods does this `case` statement use to determine which `when` clause is executed?_

---

10

```ruby
class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  @@total_people = 0

  def initialize(name)
    @name = name
  end

  def age
    @age
  end
end
```

_What are the scopes of each of the different variables in the above code?_

---

11

The following is a short description of an application that lets a customer place an order for a meal:

- A meal always has three meal items: a burger, a side, and drink.
- For each meal item, the customer must choose an option.
- The application must compute the total cost of the order.

1. Identify the nouns and verbs we need in order to model our classes and methods.
2. Create an outline in code (a spike) of the structure of this application.
3. Place methods in the appropriate classes to correspond with various verbs.

---

12

```ruby
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end
```

_In the `make_one_year_older` method we have used `self`. What is another way we could write this method so we don't have to use the `self` prefix? Which use case would be preferred according to best practices in Ruby, and why?_

---

13

```ruby
module Drivable
  def self.drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive
```

_What is output and why? What does this demonstrate about how methods need to be defined in modules, and why?_

---

14

```ruby
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```

_What module/method could we add to the above code snippet to output the desired output on the last 2 lines, and why?_
