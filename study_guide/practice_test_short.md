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

The code will output the string `'Daisy says moooooooooooo!'` and return `nil`. This is because we call the `#speak` instance method on the `Cow` instance referenced by local variable `daisy`. The `Cow` class inherits from `Animal`, which is where the `#speak` instance method is defined. The implementation of `#speak` passes the value returned by `#sound` to `puts`.

Because the calling object for `#speak` is a `Cow` instance, the implied `self` that calls `#sound` is that same `Cow` object. This means that when we invoke the instance method `#sound`, the implementation defined within the `Cow` class is executed. This implementation makes a call to `super`, which invokes the method `Animal#sound`, the method of the same name one level higher on the inheritance chain.

When `Animal#sound` is executed, we use string interpolation to get the value referenced by instance variable `@name` and interpolate it into the string returned by `Animal#sound`. In this case, because we are still dealing with the instance of `Cow` referenced by `daisy`, this will be the string `"Daisy"`, which we assign to `@name` during the initialization of the `Cow` object. Therefore, the value returned by `Animal#sound`, and therefore by `super`, is the string `"Daisy says "`.

Within the implementation of `Cow#sound`, we concatenate this value returned by `super` with the string `"moooooooooooo!`. The full value returned by `Cow#sound` therefore is, `'Daisy says moooooooooooo!'`. This value is passed to `puts` in the execution of `#speak`, which outputs the string and returns `nil`.

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

`molly` and `max` are local variables that both references different instances of the class `Cat`, defined above. They both exhibit the same behaviors. This is because they are both instances of the same class, and therefore the methods defined within are available to each, and will be implemented in the same way.

```ruby
class Cat
  def initialize(name, coloring)
    @name = name
    @coloring = coloring
  end

  def purr
    # all Cat instances will exhibit this behavior
    puts 'purr'
  end

  def jump; end

  def sleep; end

  def eat; end
end

max = Cat.new("Max", "tabby")
molly = Cat.new("Molly", "gray")

max.purr      # => purr
molly.purr    # => purr
```

The objects referenced by `max` and `molly` do not, however, share the same state the way they share the same behaviors. The state of an object is individual to itself. Here, the state is represented by the instance variables `@name` and `@coloring` and the values to which they point. We can see easily here, based on the implementation of the `Cat#initialize` constructor method that both `max` and `molly` have different states. In the object referenced by `max` the `@name` instance variable points to the string `"Max"` and in the object referenced by `molly` the `@name` instance variable points to the string `"Molly"`. This can be demonstrated by adding a getter method for `@name` to the class:

```ruby
class Cat
  attr_reader :name   # add a getter method for @name

  def initialize(name, coloring)
    @name = name
    @coloring = coloring
  end

  def purr
    # all Cat instances will exhibit this behavior
    puts 'purr'
  end

  def jump; end

  def sleep; end

  def eat; end
end

max = Cat.new("Max", "tabby")
molly = Cat.new("Molly", "gray")

max.purr      # => purr
molly.purr    # => purr

p max.name    # => "Max"
p molly.name  # => "Molly"
```

This shows how a class can act like a _template_ of an object, by outlining is available behvaiors (methods) and the attributes we might assign to each object. However, the objects themselves are separate instances of the class, whose states are not shared, which is why we can have two different `Cat` object above react similarly to the invocation of `#purr`, but still hold different data within their various states, as show by the invocation of the getter method `#name`.

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

In the above code, we initialize an instance of the class `Student` defined above and assign it to the local variable `priya`. Then we invoke the `#change_grade` instance method on that object, and pass it the argument `'A'`. Supposedly, this method should change the value referenced by `@grade` from `nil` to the string `'A'`. However, within the implementation of `#change_grade` there is an error.

Instead of calling the setter method `#grade=` defined by the line `attr_accessor :name, :grade`, we are in fact initializing a local variable `grade` and assigning our string object `'A'` to that. This does not affect the value referenced by instance variable `@grade` at all. Therefore, when we invoke the getter method `grade` on line 16, `nil` is returned. This is because `nil` was the value assigned to `@grade` during the initialization of the object referenced by `priya`.

Because of Ruby's syntactical sugar, we need to differentiate calling a setter method from local variable initialization by adding `self` to the method call. This explicitly tells Ruby to call the `grade` method on the object referenced by `self`, which in this case will be the object referenced by `priya`. Within an instance method, `self` always references the specific instance that calls the method.

```ruby
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end
  
  def change_grade(new_grade)
    self.grade = new_grade
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade                 # => 'A'
```

Once we add `self` to explicitly tell Ruby to call the setter method `#grade=`, we are able to change the value referenced by instance variable `@grade` from `nil` to `'A'`. Therefore, on line 16, the string `'A'` will be returned by the getter method `#grade`.r

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

In the above class definition for `MeMyselfAndI` we see the special reference `self` multiple times. `self` always references the object in Ruby that "owns" the portion of the code in which it is referenced. In this case, on line 2, `self` is within the class definition, but outside of any method definitions. Within a class definition, `self` will reference the class that's in the process of being defined. In this case, that will be the class `MeMyselfAndI`.

```ruby
class MeMyselfAndI
  self == MeMyselfAndI        # => true
end
```

On line 4, we see `self` used in the name of a method. This is a special use case in which `self` helps us differentiate class methods from instance methods. Because `self` within a class references the class itself, we are defining the method `::me` to be called on the _class_ rather than an instance of that class.

Further, on line 5, `self` will also reference the class `MeMyselfAndI`. This is because inside a method, `self` will reference the object that calls that method. In this case, we have a class method, so the calling object is the class `MeMyselfAndI`.

```ruby
MyMyselfAndI.me       # => MyMyselfAndI
```

On line 9, we see `self` referenced inside the instance method `#myself`. Again, inside a method `self` will reference the object that calls the method. In this case, that will be an instance of the class `MyMyselfAndI`.

```ruby
i.myself == i       # => true
```

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

In the code above we are initializing a new instance of the class `Student`, defined above, and assigning it to the local variable `ade`. Then we inspect a string representation of this object, which should show us two instance variables and their values, `@grade` which should point to `nil`, and `@name` which should point to `"Adewale"`. However, we we inspect the object referenced by `ade` we will see only the instance variable `@name` which will point to the string object `"Adewale"`.

```ruby
ade = Student.new('Adeale')
p ade
# => #<Student:0x000055b588f7ae20 @name="Adewale">
```

This is because the instance variable `@grade` is never initialized within our class definition. Though we have the default parameter `grade=nil` defined within our constructor method, this does not initialize the instance variable `@grade`. By adding the line: `@grade = grade` to the `Student#initialize` constructor method, we can initialize `@grade` to the default value of `nil` as expected.

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
    @grade = grade
  end 
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

Alternatively, we can use our setter method, defined by `attr_accessor :grade` to initialize the `@grade` instance variable

```ruby
class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
  end 
end

ade = Student.new('Adewale')
ade.grade = nil
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

Both of these additions will achieve the desired result, but the first, initializing the `@grade` instance variable during initialization is perhaps more desireable. This is because it is usually a good idea to initialize all instance variables in one step when the object in question is instantiated.

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
