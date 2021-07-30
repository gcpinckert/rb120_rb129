# Quiz Review

**Contains spoilers for quizzes continue at your own risk!**

- [Lesson 1](#lesson-1)
- [Lesson 2](#lesson-2)
- [Lesson 3](#lesson-3)
- [Lesson 5](#lesson-5)

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

## Lesson 2

### Question 1

```ruby
class Cat
  @@total_cats = 0

  def initialize(name)
    @name = name
  end

  def jump
    "#{name} is jumping!"
  end

  def self.total_cats
    @@total_cats
  end
end

mitzi = Cat.new('Mitzi')
mitzi.jump # => "Mitzi is jumping!"
Cat.total_cats # => 1
"The cat's name is #{mitzi}" # => "The cat's name is Mitzi"
```

Here we are defining the class `Cat`, as well as instantiating a new `Cat` object which is assigned to local variable `mitzi`.

On line 18, we invoke the `#jump` instance method on the `Cat` object referenced by `mitzi`. We can see that `jump` trys to access the value referenced by `@name` via a getter method in it's implementation. However, no such getter method has been defined. We can add one by adding the line

```ruby
attr_reader :name
```

to the class definition. Now the call to `name` within `jump` will return the string referenced by `@name`, in this case `'Mitzi'`, which is assigned to the instance variable during initialization.

On line 19, we invoke the `Cat` class method `::total_cats` which should return a value of `1`. Looking at the implementation for `::total_cats` we can see that it returns the value referenced by the class variables `@@total_cats`. However, `@@total_cats` is initialized to `0` and never updated in the code. We need a way to track the number of `Cat` objects that are initialized so we can get the expected value.

Since we want to increment the number of `@@total_cats` each time a new `Cat` object is instantiated, we'll add the correct logic to the `#initialize` method:

```ruby
def initialize(name)
  @name = name
  @@total_cats += 1
end
```

On line 20, we want to be able to use the object referenced by `mitzi` in string interpolation and have it output the value referenced by `@name` within the object, rather than a string representation of how the computer sees the object.

To do so, we'll override our `Object#to_s` method by redefining it in the `Cat` class like so:

```ruby
def to_s
  name
end
```

The above method relies on the `name` getter method to return the value referenced by `@name`. Now when we use `mitzi` in string interpolation, the value returned and interpolated into the string is the string object `'Mitzi'` (referenced by `@name`). This gives us the desired return value of `""The cat's name is Mitzi"` for the final line of code.

### Question 2

```ruby
class Student
  # class body
end

ade = Student.new('Adewale')
ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">
```

In the above code, we are initializing a new `Student` object and passing the string object `'Adewale'` as an argument, and assigning the result to the local variable `ade`. Based on the expected value returned by referencing `ade`, we can tell that this string argument should be assigned to the instance variable `@name` during initialization. Further, there should be another instance variable initialized, `@grade` which should reference the value `nil`.

Perhaps the easiest way to acheive the desired return value is to implement a `Student#initialize` constructor method as follows:

```ruby
def initialize(name)
  @name = name
  @grade = nil
end
```

We could also define the `Student#initialize` method such that we assign a default value for the argument `grade` in case that argument isn't provided:

```ruby
def initialize(name, grade=nil)
  @name = name
  @grade = grade
end
```

Note that because an uninitialized instance variable is always considered to reference the value `nil` by Ruby, we _must_ initialize the `@grade` instance variable in the constructor method.

```ruby
attr_accessor :grade

def initialize(name, grade=nil)
  @name = name
end
```

Above, the getter method `grade` will return `nil` not because we have set the value of `@grade` to `nil`, but because `@grade` is an uninitialized instance variable.

### Question 3

```ruby
class Student
  # assume that this code includes an appropriate #initialize method
end

jon = Student.new('John', 22)
jon.name # => 'John'
jon.name = 'Jon'
jon.grade = 'B'
jon.grade # => 'B'
```

The above code initializes a `Student` object with attributes for name, age, and grade. Based on the calls to `name`, `name=()`, `grade=()` and `grade`, we know that we will need both getter methods and setter method for the name and grade attributes.

We can define these by adding an `attr_accessor` statment to the `Student` class definition like so:

```ruby
attr_accessor :name, :grade
```

This will define both getters and setters for the instance variables listed as symbols via Ruby shorthand.

Note that we could also define the getters and setter seperately like so:

```ruby
attr_writer :name, :grade     # setter methods
attr_reader :name, :grade     # getter methods
```

### Question 4

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
sir_gallant.name # => "Sir Gallant"
sir_gallant.speak # => "Sir Gallant is speaking."
```

Here we are defining the `Character` superclass and the `Knight` subclass that inherits from `Character`. We instantiate a new `Knight` object and pass it the string `'Gallant'` as an argument, which is assigned to the `@name` instance variable based on the implementation of the inherited `Character#initialize` constructor method. The object is then assigned to the local variable `sir_gallant`.

We then invoke the `name` getter method on the object referenced by `sir_gallant`. The `Character` class defines `name` using `attr_accessor` shorthand provided by Ruby, however, `Knight` defines a separate `#name` method that overrides this implementation. The `Knight#name` method takes the string `"Sir "` and concatenates it with the value returned by `super`.

`super` looks up the inheritance chain and invokes the method of the name that invokes it from the superclass, in this case `Character#name`. `Character#name` returns the value referenced by `@name`, in this case the string `"Gallant"`. Therefore the value returned by `Knight#name` is the string `"Sir Gallant"`, which we see returned.

Then we call the `#speak` instance method on the object referenced by `sir_gallant`. This is not defined in the `Knight` class but is inherited from the `Character` class. However, looking at the implementation of `speak`, we can see that we access the `@name` instance variable directly in string interpolation. This returns only `'Gallant'`, not `'Sir Gallant'` as we wish.

We can change the instance variable `@name` to the getter method `name` inside our string interpolation instead. This will call the `Knight#name` method, which returns the value we desire (the string `'Sir Gallant'`). For instances of the class `Character`, it will still return the value referenced by `@name`, due to the implementation of `Character#name`.

This is an example of how we can rely on polymorphism to simplify our code. Both instances of `Character` and `Knight` respond to the same method call `name`, but each implementation is specific and appropriate for that particular object.

### Question 5

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

class Thief < Character; end

sneak = Thief.new("Sneak")
sneak.name # => "Sneak"
sneak.speak # => "Sneak is whispering..."
```

Here we have the subclass `Thief` which inherits from the class `Character`. We instantiate a new `Thief` object and pass it to the string `'Sneak'` as an argument. This object is then assigned to the local variable `sneak`.

First we invoke the `name` getter method on the object referenced by `sneak`. This method is defined in the `Character` class and inherited by `Thief`. It returns the value referenced by the instance variable `@name`. Because `Thief` also inherits the `initialize` constructor method from `Character`, which takes the string argument passed to it and assigns that to the instance variable `@name`, we know that value will be the string `'Sneak'`, which is what is returned.

Then we invoke the `speak` instance method on the object referenced by `sneak`. `speak` is not defined in the `Thief` class, but it is inherited from the `Character` class. However, the implementation of `speak` in `Character` is not appropriate for a `Thief` object. We can fix this by defining our own more specific `speak` method in the `Thief` class to override the implementation from `Character`.

```ruby
class Thief < Character
  def speak
    "#{name} is whispering..."
  end
end
```

Now when we invoke `speak` on a `Thief` object, it will execute the implementation defined in `Thief`, not `Character` giving us the return value we desire.

### Question 6

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
    "baaaaaaa!"
  end
end

class Cow
  def speak
    super + "mooooooo!"
  end
end

Sheep.new.speak # => "Sheep says baa!"
Lamb.new.speak # => "Lamb says baa!baaaaaaa!"
Cow.new.speak # => "Cow says mooooooo!"
```

The above code defines the superclass `FarmAnimal`, from which the subclass `Sheep` inherits. The subclass `Lamb` subsequently inherits from `Sheep`. `Cow` is a class on its own and inherits only from `Object` (at this juncture).

We then instantiate a `Sheep` object, a `Lamb` object, and `Cow` object, invoking the `speak` method on all three.

When we invoke the `speak` method on the `Sheep` object, Ruby implements the `Sheep#speak` instance method. Within the method implementation, the `super` keyword is invoked. `super` looks up the inheritance chain for a method of the same name and executes it. In this case, it finds the `FarmAnimal#speak` instance method.

Within the `FarmAnimal#speak` instance method, string interpolation is utilized to access `self`. Because we are inside an instance method `self` references the calling object, in this case, the instance of `Sheep` represented as a string. The method will return something like this, `"#<Sheep:0x000055e76af60c50> says baa!"`.

In order to access the class name as desired, we need to call the instance method `Object#class` on `self` like so:

```ruby
def speak
  "#{self.class} says "
end
```

In the case of our `Sheep#speak` method call, the above code will return `'Sheep says '`. This value is then concatenated with `'baa!'` within the `Sheep#speak` method implementation for a final return value of `'Sheep says baa!'` which is what we want.

When we invoke the `speak` method on the `Lamb` object, Ruby implements the `Lamb#speak` instance method. This method returns the string `"baaaaaaa!"`, but what we want is the string `'Lamb says baa!baaaaaaa!'`. Based on our implementation of `Sheep#speak`, we can achieve this by take the return value of `super` (which will invoke `Sheep#speak`) and concatenating it with `"baaaaaaa!"`. Because the object referenced by `self` within the instance method in this case will be an instance of the class `Lamb`, we do not need to make any further changes.

```ruby
def Lamb < Sheep
  super + "baaaaaaa!"
end
```

Finally we invoke the `speak` method on `Cow`. This will invoke the `Cow#speak` instance method. In the implementation of the method, we can see the call to `super`. However, this results in a `NoMethodError` because the `Cow` class inherits only from `Object` which does not define a `speak` method. We can fix this by causing `Cow` to inherit from the superclass `FarmAnimal` which does define a `speak` method of the implementation we want.

```ruby
class Cow < FarmAnimal
  def speak
    super + "mooooooo!"
  end
end
```

### Question 8

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

The code defines two classes, that of `Person` and that of `Cat`. We instantiate a new `Person` object and assign it to the local variable `sara`. Then we instantiate a new `Cat` object and assign it to the local variable `fluffly`.

The `Cat#initialize` constructor method is defined such that it takes two arguments, one which is assigned to the instance variable `@name` and one which is assigned to the instance variable `@owner`. Here, we pass the string `"Fluffy"` and assign it to `@name` and the value referenced by `sara` is assigned to instance variable `@owner`.

Because `sara` references a `Person` object, which is an instance of our custom class `Person`, and this object is assigned to the instance variable of another object (`@owner` for the `Cat` object `fluffy`), we can say that the object referenced by `sara` is a _collaborator object_ for the object referenced by `fluffy`.

### Question 9

```ruby
class RestaurantStaff; end

class Chef < RestaurantStaff
  def cook; end
end

class Waiter < RestaurantStaff
  def speak_to_customer; end
  def take_food_order; end
end

class MaitreD < RestaurantStaff
  def supervise; end
  def speak_to_customer; end
end

class HeadChef < Chef
  def supervise; end
end

class PastryChef < Chef
  def cook; end
end
```

In the above class structure we have a superclass `RestaurantStaff` which has child classes `Chef`, `Waiter`, and `MaitreD`. Further, both subclasses `HeadChef` and `PastryChef` inherit from the `Chef` superclass.

The `Chef` class has instance method `cook` which is inherited by `HeadChef` and `PastryChef`. However, `PastryChef` overrides this by defining it's own `cook` instance method, which would presumably have some appropriate implementation specific to the `PastryChef`. Because this repetition serves the purpose of allowing _polymorphism through inheritance_, we should leave it as is.

There is other repetition, however, which we may be able to clean up via extracting methods to a module. Both the `Waiter` class and the `MaitreD` class have an instance method `#speak_to_customer`. Presumably, the logical function of each of these is the same. By extracting the method to a module, such as `Speakable`, we can eliminate repetition in our code and simply `include` the module in the two classes.

This is a good use of _interface inheritance_ because both a `Waiter` and a `MaitreD` have an ability to speak to a customer, but they do not have a hierarchal relationship that makes them a good candidate for class inheritance.

Similarly, the `HeadChef` class and the `MaitreD` class both have an instance method `supervise`. We can also extract this method to a module to avoid repetition. Because both `HeadChef` and `MaitreD` have an ability to supervise without having a relationship of class inheritance, this is another good candidate for interface inheritance.

Refactored code:

```ruby
module Speakable
  def speak_to_customer; end
end

module Superviseable
  def supervise; end
end

class RestaurantStaff; end

class Chef < RestaurantStaff
  def cook; end
end

class Waiter < RestaurantStaff
  include Speakable

  def take_food_order; end
end

class MaitreD < RestaurantStaff
  include Superviseable
  include Speakable
end

class HeadChef < Chef
  include Superviseable
end

class PastryChef < Chef
  def cook; end
end
```

### Questions 11 - 14

```ruby
module Conversion
  # temperature and measurement conversion methods
end

class RecipeBook; end
class Recipe; end
class StarterRecipe; end
class MainCourseRecipe; end
class DessertRecipe; end
class Ingredient; end
```

The classes of `RecipeBook` and `MainCourseRecipe` naturally suggest a relationship of _collaboration_. This is because a `RecipeBook` _has_ recipies within. We can easily see assigning one or more `MainCourseRecipe` objects as attributes in `RecipeBook`.

```ruby
class RecipeBook
  attr_reader :recipes
  def initialize
    @recipes = []
  end

  def add_recipe(recipe)
    recipes << recipe
  end
end

cookbook = RecipeBook.new
cookbook.add_recipe(MainCourseRecipe.new)
p cookbook.recipes
# => [#<MainCourseRecipe:0x000055f9cc959040>]
```

Ingredients often have some aspect of measurement, so it would be appropriate to include the `Conversion` module in the `Ingredient` class via a _mixin_ or through _interface inheritance_.

```ruby
class Ingredient
  include Conversion
end
```

We can see how the classes `MainCourseRecipe`, `StarterRecipe`, and `DessertRecipe` could be subclassed from the superclass `Recipe`. This is a good place to utilize class inheritance because we see an _is a_ relationship between the children classes and the parent. That is, a `MainCourseRecipe` is a `Recipe`, a `StarterRecipe` is a `Recipe`, and a `DessertRecipe` is a `Recipe`.

This allows us to extract more generic methods into the `Recipe` superclass and leave more specific implementations in the specific subclasses.

```ruby
class StarterRecipe < Recipe; end
class MainCourseRecipe < Recipe; end
class DessertRecipe < Recipe; end
```

We would not expect to see a relationship between `RecipeBook` and `Ingredient`. That's because `Ingredient` is a collaborator in the `Recipe` (and it's subclasses) instances. `RecipeBook` deals with `Recipe` objects as part of its state, which means it does not need to be aware of any `Ingredient` objects. We can let the `Recipe` objects within take care of any interface with `Ingredient` that is required. This is an example of encapsulation.

## Lesson 3

### Question 3

```ruby
str1 = "I'm a string"
str2 = str1
```

The above code initializes the string object `"I'm a string"` and assigns it to the local variable `str1`. Then we assign the object referenced by `str1` to the local variable `str2`. At this point, both variables reference the same object in memory.

We can demonstrate this by calling the `Object#equal?` method, which checks to see if the object passed as argument is the same object in memory as the calling object.

```ruby
str1.equal?(str2)
```

This would not work with the `==` method. Though the `==` method is defined in the `Object` class to see if both the calling object and the argument are the same object in memory, there is a `String#==` instance method defined that overrides it. The `String#==` method only checks to see if the value within each object is identical, and would return `true` for two separate objects that contain the same value.

```ruby
a = 'string'
b = 'string'

a == b      # => true
a.equal? b  # => false
```

We can also check the unique object id for each object and compare them using the `object_id` method. This returns a unique numerical value for each object in memory. If those values are the same, the objects in question is the same object. If they are not, the objects in question are two different objects.

```ruby
str1.object_id == str2.object_id    # => true
```

### Question 4

```ruby
str1 = "I am a string"
str2 = "I am a string"
p str1
"I am a string"
p str2
"I am a string"
```

Here, we initialize two different string objects with identical values `'I am a string'`. Equivalence methods that check for identical values will return `true`, but those that check to see if the string objects are themselves the same object in memory will return `false`.

```ruby
str1 == str2             # => true
str1 === str2            # => true
(str1 <=> str2) == 0     # => true
str1.equal?(str2)        # => false
```

Note that above, the `===` method checks to see if the argument passed _is a member_ of the set that the calling object represents. Because all the characters in `str2` are represented within `str1`, we can say that it is a member of the set represented by `str1` and the return value is `true`.

### Question 5

```ruby
class Thing
  attr_accessor :size

  def initialize(s)
    @size = s
  end

  def ==(other_thing)
    size == other_thing.size
  end
end

thing1 = Thing.new(5)
thing2 = Thing.new(5)
thing3 = thing1
thing1.size = 4
```

Here we define class `Thing` whose instances have one attribute represented by the instance variable `@size`. We then define a `==` method, which compares the value referenced by `@size` in two instances of `Thing`.

We instantiate a new `Thing` object, whose `@size` instance variable points to the integer `5`, and assign it to local variable `thing1`. Then we instantiate another `Thing` object, whose `@size` instance variable points to the integer `5`, and assign it to local variable `thing2`. Next we initialize local variable `thing3`, and assign it the object referenced by `thing1`. Now both `thing1` and `thing3` point to the same object in memory.

Finally, we use the `size=()` setter method to reassign the `@size` instance variable in the object referenced by `thing1` to `4`. Because both local variables `thing1` and `thing3` reference the same object, this change will be reflected in both.

Therefore, when we compare `thing2` with either `thing1` or `thing3` using `==`, it will return `false`. This is because the values referenced by the `@size` instance variables within each are different.

However, if we were to use either `==` or `equal?` to compare `thing1` and `thing3`, `true` would be returned each time. This is because not only is the value referenced by `@size` identical, both objects are in fact the same object in memory.

```ruby
thing1 == thing2          # => false
thing2 == thing3          # => false
thing3 == thing1          # => true

thing1.equal?(thing2)     # => false
thing2.equal?(thing3)     # => false
thing3.equal?(thing1)     # => true
```

### Question 6

```ruby
class Circle
  attr_reader :radius

  def initialize(r)
    @radius = r
  end

  def >(other)
    radius > other.radius
  end

  def ==(other)
    radius == other.radius
  end
end

circle1 = Circle.new(5)
circle2 = Circle.new(3)
circle3 = Circle.new(5)
```

Here we define the class `Circle` whose instances will contain the attribute radius represented by the instance variable `@radius`. Then we instantiate three new `Circle` objects. A `Circle` object with a `@radius` of `5` is assigned to local variable `circle1`. A `Circle` object with `@radius` of `3` is assigned to local variable `circle2`. A `Circle` object with `@radius` of `5` is assigned to local variable `circle3`.

We also define a `>` method and a `==` method for comparison within the `Circle` class. Both methods compare the value assigned to the instance variable `@radius` for both the calling object and the object passed as argument. This means that we can compare `Circle` objects and understand if they are equal, or if one is greater than the other, based on the integer referenced by `@radius` in each.

The `==` method definition automatically implements a `!=` method, which we can use to discover if two `Circle` objects are not equal (with respect to their radius). However, the `>` does not automatically implement a `<` method, the `<` method must be separately defined on it's own if we wish to utilize it.

```ruby
circle1 > circle2      # => true
circle1 == circle3     # => true
circle1 != circle2     # => true
circle2 < circle3      # => NoMethodError
```

### Question 7

```ruby
number = 42

case number
when 1          then 'first'
when 10, 20, 30 then 'second'
when 40..49     then 'third'
end
```

Here we have a case statement, based on the value referenced by local variable `number`. In a case statment, Ruby implicitly uses the `===` method for comparison. The `===` method checks to see if the object passed as an argument is a member in the set represented by the calling object.

In this case, first Ruby will check to see if `42` (the value referenced by `number`) is a member in the set `1`. This will return `false`. Then, Ruby will check to see if `42` is a number in the set of `10`, `20`, `30`. This will return `false`. Finally, Ruby will check to see if `42` is a member in the range `40..49`. This will return `true`, so the string object `'third'` is returned by the case statement.

### Question 8

```ruby
class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  @@total_people = 0

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def age
    @age
  end
end
```

Here we define the class `Person`. Within `Person` we have a constant `TITLES` which exhibits _lexical scope_. Constants can be accessed from both instance and class methods from the class in which they are defined. However, if we want to access them from elsewhere (i.e. in a different class), we need to append that class using the _namespace resolution operator_ `::`.

```ruby
class Contact
  def initialize(person, info)
    @person = person
    @info = info
  end

  def show_info
    # access constant from the Person class
    puts Person::TITLES.sample + person.name
  end
end
```

The class variable `@@total_people` is scoped on the class level. That means it is available throughout the class it is defined, in either class or instance methods. However, if we want to access it outside the class, we need to define a public method as an interface that allows us to do so.

```ruby
def self.total_people
  @@total_people
end
```

The instance variable `@name` and the instance variable `@age` are available on the object level. That is, they are available within any instance methods defined within the class. In fact, even if the instance variable is not initialized, it will not throw a `NameError`. Rather, Ruby will consider the instance variable in question to point to `nil`. This is the case for the above example `@age`, which is never initialized within the class. Ruby will consider this to reference `nil`.

```ruby
joe = Person.new('Joe')
p joe.age                   # => nil
p joe                       # => #<Person:0x00005653fc30e390 @name="Joe">
```

### Question 9

```ruby
module Speedy
  def run_fast
    @speed = 70
  end
end

class Animal
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Dog < Animal
  DOG_YEARS = 7

  def initialize(name, age)
    @dog_age = age * DOG_YEARS
  end
end

class Greyhound < Dog
  include Speedy
end

grey = Greyhound.new('Grey', 3)
```

Here we have the module `Speedy`, the superclass `Animal` with subclass `Dog` which is also superclass to subclass `Greyhound`. Then we instantiate a new `Greyhound` object and assign it to the local variable `grey`.

`Greyhound` includes the module `Speedy`, so the initialized object will have access to the instance variable `@speed`. However, `@speed` is not initialized until we call the `run_fast` instance method, so at the moment Ruby will consider it to reference `nil`.

`Greyhound` inherits the `initialize` method from the superclass `Dog` which takes two arguments, `name` and `age`. During initialization, it will initialize the `@dog_age` instance variable and assign it to the value returned by `age * DOG_YEARS`.

There is also an `initialize` method in the superclass `Animal` which initializes the instance variables `@name` and `@age`. However, because this method is overridden by the `Dog#initialize` method, these instance variables are never initialized, and Ruby will consider them to reference `nil`.

```ruby
grey = Greyhound.new('Grey', 3)
p grey
# => #<Greyhound:0x0000561871c8dd10 @dog_age=21>
# only the @dog_age instance variable is initialized

# initializes the @speed instance variable
grey.run_fast
p grey
# => #<Greyhound:0x00005653487409e0 @dog_age=21, @speed=7>

# we cannot initialize @name and @age unless we instantiate an `Animal` object
```

### Question 10

```ruby
class Shape
  @@sides = nil

  def self.sides
    @@sides
  end

  def sides
    @@sides
  end
end

class Triangle < Shape
  def initialize
    @@sides = 3
  end
end

class Quadrilateral < Shape
  def initialize
    @@sides = 4
  end
end
```

Here we define the superclass `Shape` and the subclasses `Triangle` and `Quadrilateral` both of which inherit from `Shape`. Within `Shape`, we initialize the class variable `@@sides` and set it's value to `nil`. `@@sides` is available in both `Triangle` and `Quadrilateral` which inherit from `Shape`, however, only one copy is shared between all instances of all three classes.

Therefore, when we reassign `@@sides` to `3` during initialization of a new `Triangle` object, it will change the value of `@@sides` to `3`, regardless of where we reference it from. Similarly, when we reassign `@@sides` to `4` during initialization of a new `Quadrilateral` object, it changes the value of `@@sides` to `4` regardless of where we reference it from.

```ruby
p Shape.sides             # => nil
p Triangle.sides          # => nil
p Quadrilateral.sides     # => nil

Triangle.new

p Shape.sides             # => 3
p Triangle.sides          # => 3
p Quadrilateral.sides     # => 3

Quadrilateral.new

p Shape.sides             # => 4
p Triangle.sides          # => 4
p Quadrilateral.sides     # => 4
```

### Question 11

```ruby
module Describable
  SIDES = nil

  def describe_shape
    "I am a #{self.class} and have #{SIDES} sides."
  end
end

class Shape
  include Describable

  def self.sides
    SIDES
  end
end

class Quadrilateral < Shape
  SIDES = 4
end

class Square < Quadrilateral; end

Square.sides # => 4
Square.new.sides # => 4
Square.new.describe_shape # => "I am a Square and have 4 sides."
```

Here we have the module `Describable` which is included in the superclass `Shape`. The subclass`Quadrilateral` inherits from `Shape`, and further, the subclass `Square` inherits from `Quadrilaterial` (and therefore both have the methods of `Describable` available to them).

We then attempt to call the class method `::sides` on the `Square` class, which should return the value referenced by the `Quadrilateral` constant `SIDES`. This constant is inherited by `Square`. However, the method is defined in the `Shape` class, which does not have access to the constant initialized in `Quadrilateral` without the namespace resolution operator. In order to access the constant `SIDES`, we need to append `self::` to `Sides`. `self` will reference the calling object, in this case the class `Square`, which allows us to access the constant `SIDES`.

```ruby
def self.sides
  self::SIDES
end
```

Next, we attempt to call an instance method `sides` on a newly instantiated `Square` object. However, no such instance method is defined, only the class method `::sides` which must be called directly on the class. We can fix this by either defining a new instance method `sides`. This method can be in either the `Shape`, `Quadrilaterial` or `Square` class.

```ruby
def sides
  SIDES
end
```

Finally, we call the `describe_shape` method on a new `Square` instance. Within the method, we again try to reference `SIDES`. However, we do not have access to the `SIDES` constant within the module, as it is initialized in the `Quadrilateral` class. Again, we can rely on the namespace resolution operator here to get us what we need. In this case, we need to append `self.class::` to the reference to `SIDES`. That's because in this case, `self` references the calling object, an instance of the class `Square`. Adding the call to `class` gets us the class object itself, to which we append the namespace resolution operator `::`.

```ruby
"I am a #{self.class} and have #{self.class::SIDES} sides."
```

Fully refactored code:

```ruby
module Describable
  def describe_shape
    "I am a #{self.class} and have #{self.class::SIDES} sides."
  end
end

class Shape
  include Describable

  def self.sides
    self::SIDES
  end
end

class Quadrilateral < Shape
  SIDES = 4
  
  def sides
    SIDES
  end
end

class Square < Quadrilateral; end

p Square.sides # => 4
p Square.new.sides # => 4
p Square.new.describe_shape # => "I am a Square and have 4 sides."
```

## Lesson 5

### Question 2

Using the following short description of the application, create  a potential structure to model the necessary classes and methods

- The application lets a customer place an order for a meal.
- A meal always has three meal items: a burger, a side, and drink.
- For each meal item, the customer must choose an option.
- The application must compute the total cost of the order.

Nouns: customer, order, meal item, burger, side, drink
Verbs: place order, choose option, calculate total

```ruby
class Customer
  # this represents user

  def place_order
  end
  
  def choose_option
  end
end

class Order
  # will contain at least three meal items

  def calculate_total
    # use each meal item to calculate total
  end
end

class MealItem
  # has a price
  # has option(s)
end

class Burger < MealItem
end

class Side < MealItem
end

class Drink < MealItem
end
```

## Questions 3-7

```ruby
class Customer
  def place_order
    @order = Order.new
  end
end

class Order
  def initialize
    @burger = Burger.new
    @side = Side.new
    @drink = Drink.new
  end
  
  def meal
    [@burger, @side, @drink]
  end

  def to_s
    meal.map(&:to_s).join(', ')
  end

  def total
    total_cost = @burger.cost + @side.cost + @drink.cost
    format("$%.2f", total_cost) # #format formats the cost to two decimal places
  end
end

class MealItem

  def initialize
    @option = choose_option
  end
  
  def choose_option
    puts "Please choose a #{self.class} option:"
    puts item_options # item_options returns a list of options and prices
                      # for a particular item type
    gets.chomp
  end

  def to_s
    self.class::OPTIONS[@option][:name]
  end

  def cost
    self.class::OPTIONS[@option][:cost]
  end
end

class Burger < MealItem
  OPTIONS = {
    '1' => { name: 'LS Burger', cost: 3.00 },
    '2' => { name: 'LS Cheeseburger', cost: 3.50 },
    '3' => { name: 'LS Chicken Burger', cost: 4.50 },
    '4' => { name: 'LS Double Deluxe Burger', cost: 6.00 }
  }
end

class Side < MealItem
  OPTIONS = {
    '1' => { name: 'Fries', cost: 0.99 },
    '2' => { name: 'Onion Rings', cost: 1.50 }
  }
end

class Drink < MealItem
  OPTIONS = {
    '1' => { name: 'Cola', cost: 1.50 },
    '2' => { name: 'Lemonade', cost: 1.50 },
    '3' => { name: 'Vanilla Shake', cost: 2.00 },
    '4' => { name: 'Chocolate Shake', cost: 2.00 },
    '5' => { name: 'Strawberry Shake', cost: 2.00 }
  }
end
```

<!-- markdownlint-disable-file MD024 -->
