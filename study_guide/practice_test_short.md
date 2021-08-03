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

6 (13:07)

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

In the above code, we initialize a new instance of the class `Knight`, defined above, and assign it to the local variable `sir_gallant`. Then we call the `name` instance method on that object. This outputs the string `'Sir Gallant'`. If we look at the implementation of the `Knight` class, we can see that there is a `Knight#name` instance method which overrides the `name` method inherited from the `Character` class. Note that the `Character#name` instance method comes from the `attr_accessor :name` statement on line 2.

Within the `Knight#name` instance method we are taking the string `"Sir "` and concatenating it with the value returned by `super`. `super`, in Ruby, is a special keyword that looks up the class inheritance chain for a method of the same name of the one that invokes it, and executes that method. In this case, it will execute the `Character#name` getter method defined by `attr_accessor :name`. The `attr_accessor` is Ruby shorthand that gives us a "default" getter method implementation that simply returns the value referenced by the instance variable of the same name. It acts just as the following method:

```ruby
def name
  @name
end
```

In this case, due to the implementation of the `Character#initialize` constructor method (which is inherited by Knight), the `@name` instance variable in the object referenced by `sir_gallant` points to the string `"Gallant"`, which we passed as an argument during object instantiation. This string is concatenated with `"Sir "` in the `Knight#name` method and we get the string `'Sir Gallant'`, which is output by `p`.

Next, we call the `#speak` instance method on the `Knight` instance referenced by `sir_gallant`. There is no `#speak` method defined in the `Knight` class, but there is one defined in `Character` that is inherited. Within this method, the `@name` instance variable (which points to `'Gallant'`) is accessed directly and interpolated into the string `"Gallant is speaking"`, which is returned and passed to `p` for output.

Because we have a special formatting we want for the value referenced by `@name` in our `Knight` objects, we should rely on accessing the value referenced by `@name` via our getter method `Knight#name`. Within our `Character#speak` method, we can simply call the `name` getter method within the string interpolation instead of referencing the instance variable directly. For instances of the class `Character` this will return the value referenced by `@name` and for instances of the class `Knight` this will return the value referenced by `@name` prepended by `'Sir '` which is what we want.

```ruby
def speak
  "#{name} is speaking."
end

sir_gallant = Knight.new("Gallant")
spongebob = Character.new("Spongebob")

p sir_gallant.speak         # => Sir Gallant is speaking
p spongebob.speak           # => Spongebob is speaking
```

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

Here we have four class definitions. The superclass `FarmAnimal` from which the subclasses `Sheep` and `Cow` both inherit. `Sheep` is also superclass to the `Lamb` class which inherits all methods from `Sheep` and `FarmAnimal` as well. Then we instantiate three objects, one of the class `Sheep`, one of the class `Lamb`, and one of the class `Cow`, and call the `#speak` instance method on each.

When we call the `#speak` instance method on `Sheep` Ruby executes the `Sheep#speak` instance method as this is the first class searched in the method lookup chain. the `Sheep#speak` instance method invokes `super`, which looks up the inheritance chain (in this case to the `FarmAnimal` class) and executes the method of the same name that it finds (in this case `FarmAnimal#speak`). Within the `FarmAnimal#speak` method we use string interpolation to access the calling object as a string representation and add it to the string `" says"`. Because we have no class specific `to_s` defined, this will execute the default implementation from the class `Object`, which returns ``#<Sheep:0x000055648c2910d0>` Then,  within the `Sheep#speak` method this string is concatenated with the string `"baa!"` which is returned by the call to `Sheep#speak` and passed to `p` for output. The full output will be the string `"#<Sheep:0x000055648c2910d0> says baa!"`.

Next we invoke the `#speak` method on the `Lamb` object. This executes the code within the `#speak` method defined in the class `Lamb`. This also has a call to `super`, which will execute the `Sheep#speak` method explained in the above paragraph. This time, however, the object referenced by `self` in the `FarmAnimal#speak` method will be an instance of `Lamb`, so the string representation becomes `'#<Lamb:0x000055648c290ef0>"`. The full output will be `"#<Lamb:0x000055648c290ef0> says baa!baaaaaaa!"`.

Finally, we invoke the `speak` method on the instance of `Cow`. This executes the `Cow#speak` method which also has a call to `super`, executing the `FarmAnimal#speak` method once again, and concatenating the result with `"mooooooo!"`. Again, `self` will reference the calling object, the instance of `Cow` and a string representation of that object (`#<Cow:0x000055648c290ce8>`) is interpolated into the return value string. The full output becomes `"#<Cow:0x000055648c290ce8> says mooooooo!"`.

To have a friendlier representation of each object as a string, we might consider defining a `to_s` method in the `FarmAnimal` superclass. This will override the default behavior of `to_s` as defined in object and allow us to tell Ruby how we want these objects represented as a string. Because all the subclasses inherit in some way from the `FarmAnimal` superclass, we only have to write this method once:

```ruby

class FarmAnimal
  def speak
    "#{self} says "
  end

  def to_s
    self.class.to_s
  end
end
```

Now the output becomes:

```ruby
p Sheep.new.speak         # => "Sheep says baa!"
p Lamb.new.speak          # => "Lamb says baa!baaaaaaa!"
p Cow.new.speak           # => "Cow says mooooooo!"
```

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

In the code above, we define the class `Person` and the class `Cat`. We then instantiate a new `Person` object, passsing the string object `"Sara"` as an argument and assigning it to the instance variable `@name` according to the `Person#initialize` constructor method. The `Person` object is then assigned to the local variable `sara`. The string object `"Sara"` is considered to be a collaborator object, as we are assigning it to be a part of the _state_ of the `Person` object referenced by `sara`.

We then initialize a `Cat` object and pass it the string `"Fluffy"` and the `Person` object referenced by `sara` as arguments. The string `"Fluffy"` is assigned to the `@name` instance variable and the `Person` object `sara` is assigned to the `@owner` instance variable. This is executed according to the `Cat#initialize` constructor method, which is invoked upon initialization by the class method `::new`. Both the string `"Fluffy"` and the `Person` instance referenced by `sara` are considered to be collaborator objects, because they are both values assigned to instance variables within the `Cat` object referenced by `fluffy`.

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

In Ruby, a case statement implicity uses the `===` method to compare objects after `when` with the object in the `case` statement. This `===` method is often defined for the built in object type. For example, in the code snippet above, the `case` statement will use `Integer#===` for the first two `when` clauses and `Range#===` for the final `when` clause. When `#===` is called with an object that represents a collection, it is often implemented such that it's asking, "is the object passed as argument included in the collection that called the method?". This polymorphism is what allows us to use both integers and ranges in a single case statement. While the `===` method will check for equality in the first two `when` clauses, in the third it will simple see if the value referenced by `number` (in this case, the integer `42`) is included in the range `40..49`. Here, this will return `true`, so the code following `then` executes and the case statement returns the string `'third'`.

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

Within the class `Person` we have the constant `TITLES`. Constants, when initialized within class definitions exhibit lexical scope. This means that they can be accessed from both instance and class methods within the class in which they are initialized. However, if we want to access them from elsewhere (such as in a different class or within the main scope of the program) we need to append the class name to which they belong using the namespace resolution operator.

```ruby
class ContactCard
  def initialize(person, address, phone_number)
    @person = peron # we pass a Person collaborator object here
    @address = address
    @phone_number = phone_number
  end

  def show_info
    puts "#{Person::TITLES.sample} #{person}" # access the TITLES constant in a different class
    # etc...
  end

  private

  attr_reader :person, :address, :phone_number
end
```

Within the class `Person` we also have the class variable `@@total_people` defined. This is scoped on the class level, meaning it is available within all instance and class methods defined for that particular class. Important to not is that all instances of a class share a _single_ copy of an instance variable. So modifying it through one object will affect it no matter where it is referenced.

```ruby
class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  @@total_people = 0

  def initialize(name)
    @name = name
    @@total_people += 1
  end

  def age
    @age
  end

  def self.total
    @@total_people
  end
end

Person.total                # => 0
joe = Person.new('Joe')
Person.total                # => 1
```

Within the class `Person`, we also have the instance variables `@name` and `@age`. Instance variables are scoped at the object level, meaning they must be accessed through the specific instance of the class to which they pertain. They are available throughout the instance methods defined within the class (because these are scoped on the object level), but otherwise we must have specifically defined _setter and getter_ methods in order to access them through the object. The `Person#age` method is an example of one such getter method for the instance variable `@age`.

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
