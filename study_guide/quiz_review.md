# Quiz Review

## Lesson 1

### Question 8

```ruby
class Cat
end

whiskers = Cat.new
ginger = Cat.new
paws = Cat.new
```

In the above code, we define the class `Cat`. Then we instantiate three separate `Cat` objects, assigning each to the local variables `whiskers`, `ginger`, and `paws` respectively. In this case, each local variable will reference a _separate and distinct_ `Cat` object.

```ruby
p whiskers.equal?(ginger)     # => false
p ginger.equal?(paws)         # => false
p paws.equal?(whiskers)       # => false
```

Note that the code does not require an `initialize` method to function. This is because `initialize` is merely a part of the instantiation process accomplished by `::new`. We only require an `initialize` method if the object in question has a specific requirement for it's implementation of `initialize`.

### Question 9

```ruby
class Thing
end

class AnotherThing < Thing
end

class SomethingElse < AnotherThing
end
```

In the above code, we define three classes in a hierarchal structure. First, there is the class `Thing`, which is the superclass for subclass `AnotherThing`. Then there is `AnotherThing` which is the superclass for the subclass `SomethingElse`. `AnotherThing` will inherit all the methods defined in `Thing`. `SomethingElse` will inherit all the methods defined in both `AnotherThing` and `Thing` (because the inherited methods from `AnotherThing` include those from `Thing`, not because `SomethingElse` inherits from `Thing` directly).

Note that all classes in Ruby inherit from the `Object` superclass. Therefore the total number of superclasses in the code snippet is in fact three: `Thing`, `AnotherThing`, and `Object`.

### Question 10

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

The above code demonstrates a chain of inheritance that includes both class and interface inheritance. Ruby has specific rules for how it progresses along the method lookup chain in a linear fashion:

- First Ruby will check the `Penguin` class. It always begins with the class belonging to the calling object and progresses "upward" or "outward".
- Next, Ruby will check `Migratory`. Ruby checks all modules included in the "current" class before moving up to a superclass. It does this in a specific order, from the last included module on up (reverse order to how they are included).
- Next, Ruby will check `Aquatic`. This is also included in the `Penguin` class but it is included before `Migratory` so will be the second module that's checked.
- Next, Ruby will check the `Bird` superclass, which is the class that `Penguin` subclasses from.
- `Bird` includes no modules and subclasses from `Animal`, so Ruby will check the `Animal` class next.
- Next, Ruby will check the `Object` class, from which all classes in Ruby inherit.
- Finally, Ruby will check the `BasicObject` class, the parent of `Object`.

In the above example, the `fly` method is defined in the `Flight` module, which is not in the method lookup path for `Penguin`. Therefore, in this case, Ruby will progress all the way through the method lookup chain and never find a matching `fly` method. The code will through a `NoMethodError`.

### Question 11

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

In the above code we define the class `Animal` and `Cow` before instantiating a `Cow` object (`daisy`) and calling the `speak` method on it. The `speak` method is defined in the `Animal` superclass from which `Cow` inherits. So first Ruby will invoke the `Animal#speak` method.

The implementation of `speak` invokes the `sound` method. There is a `sound` method defined in the `Animal` class, but it is overridden by the `sound` method in the `Cow` subclass. Because `daisy` is an instantiation of `Cow`, Ruby will execute the `Cow#sound` method.

Within the `Cow#sound` implementation, we see the keyword `super`. This causes Ruby to go up a level in the inheritance chain and invoke the method of the same name, in this case `Animal#sound`. `Animal#sound` returns the string `"Daisy says"` (accessing the value referenced by `@name` using string interpolation). Back within the implementation of `Cow#sound` we concatenate this return value with the string `'moooooooo!'`, giving us a return value of `'Daisy says mooooooo!'`

This value is then passed to `puts` as an argument back within the implementation of `Animal#speak`. Therefore, the code `daisy.speak` will output the string `'Daisy says mooooooo!'` and return `nil`.

### Question 12

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

In the above code, we define the class `Cat` whose instances will have the attributes of a name and a color as well as having the methods `purr`, `jump`, `sleep`, and `eat`.

We then instantiate a new `Cat` object and assign it to the variable `max`. When we create a new `Cat` object with `::new`, the instance method `initialize` is called on it. `Cat#initialize` accepts two arguments, which are assigned to the instance variable `@name` and `@coloring`. In this case, we are assigning the string `'Max'` to `@name` and the string `'tabby'` to `@coloring`.

Next, we instantiate another `Cat` object and assign it to the variable `molly`. In this case, we pass different string arguments to the `#initialize` instance method. So in the `molly` `Cat` object, the `@name` instance variable will reference the string `'Molly'` and the `@coloring` instance variable will reference the string `'gray`'.

In this case, we can say that we have two separate `Cat` objects in memory, both of which will exhibit the same behaviors (the methods defined in `Cat`), but each of which exhibit a different `state` (the values references by instance variables `@name` and `@coloring`).

We can demonstrate this by defining getter methods for the instance variables and accessing the values they reference outside the class:

```ruby
class Cat
  attr_reader :name, :coloring

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

max.name == molly.name            # => false
max.coloring == molly.coloring    # => false

max.purr
molly.purr
# both methods will execute
```

### Question 14

```ruby
kate = Person.new
kate.name = 'Kate'
kate.name # => 'Kate'
```

In the above code, we are initializing a new `Person` object and assigning it to the local variable `kate`. No arguments are passed when calling `::new`, so we can assume that any instance variables are not initialized within the `initialize` method via values passed as arguments.

Then we call a setter method for some instance variable `@name` within the person object, assigning the value `'Kate'` to the `@name` instance variable.

Next, we call a getter method for that same instance variable `@name`, which returns the value referenced by `@name`, in this case, the string object `'Kate'`.

We could define the class `Person` in the following ways in order to execute the above code with the expected results:

```ruby
class Person
  attr_accessor :name
end
```

In this case, we define both a getter and a setter method for the instance variable `@name` using Ruby's `attr_*` shorthand. Because this will define a setter method that initializes the `@name` instance variable for us when called, we will still get the expected results when executing the given code.

```ruby
class Person
  attr_writer :name

  def name
    @name
  end
end
```

Similarly, the above code will work when executing the given code. This is because the `attr_writer` statement defines a setter method that initializes the instance variable `@name`, and the `name` method defines a getter method we can use to access the value referenced by that same instance variable.

```ruby
class Person
  attr_reader :name

  def name=(name)
    @name = name
  end
end
```

Here we are using Ruby's `attr_*` shorthand to define a getter method, and we define a setter method `name=()` manually. The `@name` instance variable is initialized within the setter method `name=()` so the code will execute as expected.

```ruby
class Person
  def name
    @name
  end

  def name=(name)
    @name = name
  end
end
```

Finally, here we define all both the setter method `name=()` and the getter method `name` manually. The setter method `name=()` initializes the `@name` instance variable so the code will execute as expected.

### Question 15

```ruby
class Person
  attr_writer :first_name, :last_name

  def full_name
    # omitted code
  end
end

mike = Person.new
mike.first_name = 'Michael'
mike.last_name = 'Garcia'
mike.full_name # => 'Michael Garcia'
```

Here we are defining the class `Person`, whose object will have the attributes `first_name` and `last_name` as aspects its state. We initialize a new `Person` object and assign it to the local variable `mike`. Then we use the setter method defined by the `attr_writer` statement to assign the string `'Michael'` to the instance variable `@first_name` of the `Person` object references by `mike`.

Similarly, we use the setter method defined by the `attr_writer` statement to assign the string `'Garcia'` to the instance variable `@last_name` in the `Person` object referenced by `mike`. Finally, we call the `full_name` instance method, which should output the value referenced by `@first_name` followed by a space followed by the value referenced by `@last_name`.

Because we have no getter method defined by our `attr_writer` statement, only a setter method, we must access the instance variables `@first_name` and `@last_name` directly within the `full_name` method in order to access the values they reference. The method implementation should look like this:

```ruby
@first_name + ' ' + @last_name
```

### Question 16

```ruby
class Student
  attr_accessor :name, :grade

  def initialize(name)
    @name = name
    @grade = nil
  end
end

priya = Student.new("Priya")
priya.change_grade('A')
priya.grade # => "A"
```

In the above code, we define the class `Student`. A `Student` object is initialized with two instance variables, `@name` which is assigned to the argument passed with `::new` and `@grade` which is assigned to the value `nil`. `Student` defines a getter and a setter method for both `@name` and `@grade` using Ruby's shorthand `attr_accessor`. 

We instantiate a new `Student` object with `::new` and assign it to the local variable `priya`. Then we call the `change_grade` instance method on that object and pass it the string `'A'` as an argument. Calling the getter method `grade` on the object referenced by `priya` is expected to return that same string `'A'`, so we can assume that the implementation of `change_grade` either employs the setter method `grade=()` or reassigns the instance variable directly.

```ruby
# option 1
def change_grade(new_grade)
  self.grade = new_grade
end
```

Above, we use the setter method `grade=()` in order to reassign instance variable `@grade` to the desired value. We must use the keyword `self`, which references the calling object within instance methods, in this case the object referenced by `priya`, in order to distinguish the setter method's syntactical sugar from local variable assignment.

```ruby
# option 2
def change_grade(new_grade)
  @grade = new_grade
end
```

We can also reassign `@grade` by accessing it directly within `change_grade`, however this is perhaps not the most advisable way to go about it. Generally, code is more maintainable if we utilize our setter method for reassignment of instance variables.

### Question 17

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

In the above code, we have the class definition `MeMyselfAndI` which utilizes the keyword `self` in multiple places. The value referenced by `self` changes depending on the scope that it is used in.

On line 2, when `self` is called in the class definition, `self` will reference the class itself. In this case, `MeMyselfAndI`. On line 4, `self` is still in the scope defined by the class definition, so it also references the class `MeMyselfAndI`. Further, because we see this call to `self` affixed to the beginning of the method name in a method definition, we can see it is being used to distinguish a class method definition from an instance method definition.

On line 5, within the class method `::me` will reference the object that calls the method, which in this case is again the class `MeMyselfAndI`.

On line 9, within the instance method `#myself`, `self` will reference the calling object for the method. Here, `#myself` is an instance method so it will be the object that is an instance of the class `MeMyselfAndI` that `self` references.
