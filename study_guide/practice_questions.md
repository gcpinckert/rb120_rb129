# Open Ended Practice Questions

[OOP](#oop)
[Classes and Objects](#classes-and-objects)
[Encapsulation](#encapsulation)
[Method Access Control](#method-access-control)
[Polymorphism](#polymorphism)
[Inheritance](#inheritance)
[Modules](#modules)
[Method Lookup Path](#method-lookup-path)
[Constants](#constants)
[Getters and Setters](#getters-and-setters)

## OOP

__What is OOP and why is it important?__

Object Oriented Programming is essentially an organizing system that allows us to write more flexible and maintainable code. The way data is passed around a procedural program often causes a mass of interdependencies. This makes it difficult to make changes or update code, as changes must be made in many different places: wherever the data we are changing is "touched". OOP gives us the ability to write clearly organized code within a series of classes, objects, and modules. We can treat these as "building blocks" for big complex programs. Code within each "block" can be changed without affecting the entire program, and some blocks can be reused in order to cut down on repetition.

There are a number of benefit to using OOP design when building our programs. By _encapsulating_ data within object, it offers a level of protection and security. With the intentional separation of an object's behavioral _implementation_ and it's _public interface_ we can ensure that data is being changed and manipulated only in ways appropriate to the object in question.

Further, the modeling of problems on a metaphorical level and separating responsibilities across various objects and classes allows us as programers to think with a higher level of abstraction. Not only does this result in cleaner more organized code, but it often leads to more flexibility in thinking about how to solve the problem in question.

__What is a spike?__

A spike is a kind of "rough draft" in designing how you want to delegate different responsibilities in OOP programs. This is achieved by modeling the problem using real world scenarios. First we want to write out a quick description of the steps in the desired program. Then we want to extract the nouns and verbs from that description. The nouns will represent our potential classes and the verbs will represent our potential behaviors.

Next, we'll take the extracted verbs and organize them appropriately among the nouns. This gives us the beginnings of a class outline.

__What is a sign that you are missing a class?__

Repetitive nouns can be a sign that you are missing a class.

## Classes and Objects

__What is an object?__

An object is an _instance_ of a class. You can think of it as the real world representation of the blueprint that the class represents. In Ruby, anything that has _value_ is considered to be an object. Individual objects contain different information (their _state_), but can still be instances of the same class.

__How do you initialize a new object?__

A new object can be instantiated by calling the class method `::new` on the class itself. This method will then invoke the instance method `#initialized` which can be defined in order to initialize an object in a certain way / to encapsulate a certain state. This is known as a constructor method.

```ruby
Hash.new # => {}
String.new # => ''

class Person
  def initialize(name)
    @name = name
  end
end

Person.new('Jane')  # => #<Person:0x0000559f46356c50 @name="Jane">
```

__What is an instance variable, and how is it related to an object?__

An instance variable is a special kind of variable that is scoped on the object level. It is only available through the object, via any setter and getter methods we've supplied as part of the object's public interface. It represents a single aspect of an object's "state", that is, a single value (or collection of values) that are part of the data encapsulated within the object.

```ruby
class Person
  def initialize(name)
    @name = name
  end

  def introduce
    puts "Hi my name is #{@name}"
  end
end

jill = Person.new('Jill')
jack = Person.new('Jack')
jill.introduce            # => 'Hi my name is Jill'
jack.introduce            # => 'Hi my name is Jack'
```

In the code above, we initialize two new `Person` objects and assign them to the variables `jack` and `jill`. When the objects are initialized, we pass each the string `'Jill'` and `'Jack'` respectively. `'Jill'` is assigned to the `@name` instance variable for the `Person` object referenced by `jill` and `'Jack'` is assigned to the `@name` instance variable for the `Person` object referenced by `jack`. This is demonstrated when we call the `#introduce` method on both objects, and each individual `@name` value is output.

As can be seen above, instance variables are available throughout the instance methods of the class. This is because the instance methods are scoped on the _object level_, that is, because they are invoked on the calling object, they have access to any data encapsulated within that object.

__What is an instance method?__

An instance method are methods defined within a class that define behavior available to instances of that class. Unlike the _state_ of an object as represented by it's attributes, instance methods represent the behaviors available to an object, and any object that is an instance of the class in question will have access to these behaviors.

Instance methods may rely on data encapsulated within an object for their implementation. In this case, it's possible to see different outputs or return values depending on the data within the calling object. The behavior, however, is always the same.

```ruby
class Person
  def initialize(name)
    @name = name
  end

  def introduce
    puts "Hi, my name is #{@name}!"
  end

  def say_goodbye
    puts "See you later!"
  end
end

jack = Person.new('Jack')
jill = Person.new('Jill')

# instance method that outputs an objects @name attribute
jack.introduce        # => 'Hi, my name is Jack!'
jill.introduce        # => 'Hi, my name is Jill!'

# instance method that does not utilize the particular state of an object
jack.say_goodbye      # => "See you later!"
jill.say_goodbye      # => "See you later!"
```

__How can you see if an object has instance variables?__

This can be achieved in two ways, either by inspecting a string representation of the object (which contains any initialized instance variables as well as the value they point to) or by calling the `Object#instance_variables` method on the object (which returns an array of symbols representing initialized instance variables).

Note that both approaches only provide instance variables that have been initialized for the object. In order to initialize a variable it must either be initialized during object instantiation or the method that contains it's initialization must be called.

```ruby
class Person
  def initialize(name)
    @name = name
  end
  
  def age
    @age
  end
end

j = Person.new('Jane')

p j
# => #<Person:0x0000559f46356c50 @name="Jane">
# note that @age is not provided here

p j.instance_variables
# => [:@name]
```

__What is a class? What is the relationship between a class and an object?__

A class is a way to group together shared behaviors for a certain type of objects. A class is ostensibly the blueprints for objects, which are instances of a class. A class contains all the methods (or behaviors) of an object's public interface as well as the private methods that are a part of that object's implementation. A class also contains the outline of an object's attributes, through defining various instance variables. These attributes, however, are not actualized until an object is instantiated and the instance variable in question is initialized.

__What is the difference between states and behaviors?__

A class outlines both the states and behaviors for it's object. A state is something that is particular to an individual object, representing as a whole all the data that is encapsulated within that particular object. Behaviors, on the other hand, describe all the methods that any object of a given class can invoke.

```ruby
class Fish
  def initialize(type)
    # instance variable stores data pertaining to particular instance
    @type = type
  end

  # instance method defines behavior available to all objects of that class
  def swim
    puts "The #{@type} is swimming!"
  end
end

nemo = Fish.new('clownfish')    # => #<Fish:0x0000563bc8206b38 @type="clownfish">
bruce = Fish.new('shark')       # => #<Fish:0x0000563bc823dd68 @type="shark">
nemo.swim                       # => The clownfish is swimming!
bruce.swim                      # => The shark is swimming!
```

Above, we create two different Fish objects. They both have an instance variable `@type` (initialized during instantiation), and each points to a different value. In the case of `nemo` `@type` references the string `'clownfish'` and in the case of `bruce` `@type` references the string `'shark'`. Because we have only one attribute defined here, the instance variable `@type` along with the value it references would consist of the individual objects _state_.

Regardless of the data they each encapsulate, both fish objects have access to the _behavior_ defined by the instance method `#swim`. When we invoke `#swim` on any given `Fish` instance, it will display that particular object's attribute `@type`.

__Classes also have behaviors not for objects (class methods). How do you define a class method?__

Class methods are a type of method that we call directly on the class itself. It is not required that we instantiate any object before calling a class method. In face, we call on a class method to do so, the class method `::new`.

Class methods help us keep track of class level details that pertain to the class itself, as opposed to those that pertain to any particular instance of that class.

When defining class methods, we need to differentiate them from isntance methods, which we do by appending the special variable `self` to the method name.

```ruby
def self.class_method
  # implementation
end
```

This works because within a class definition (but outside of a method) `self` references the class. Adding the call to `self` here will tell Ruby explicitly that this is a method we are defining to be called on the class.

```ruby
class Dog
  def self.species
    'canis lupis familiaris'
  end
end

Dog.species   # => 'canis lupis familiaris'
```

__What is a collaborator object? What is the purpose of using collaborator objects in OOP?__

A collaborator object is an object that is assigned as a value for another object's instance variable, and as such becomes a part of the other object's state. A collaborator object can be a built-in type (such as a string or an array) but it can also be a custom defined object we create as part of the program.

The structure of how we assign various objects to interact as collaborators defines the connections between different classes (or modules) in the program. These can be used as distinct "building blocks" in order to separate the problem out into self sustaining pieces.

For example, let us say that we have a class `Library` that represents a collection of `Book` objects. We would consider the `Book` objects to be collaborates with the class `Library`. This is because these are separate objects with a separate interface that we add to an attribute of `Library`. The `Book` interface interacts meaningfully with the `Library` implementation, allowing us to access that interface without necessarily needing to know about it through our manipulations of the `Library` class.

```ruby
class Library
  attr_accessor :books

  def initialize
    @books = []
  end

  def <<(book)
    books.push(book)
  end

  def checkout_book(title, author)
    book = Book.new(title, author)
    if books.include?(book)
      books.delete(book_to_checkout)
    else
      puts "The library does not have that book"
    end
  end
end

class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title = title
    @author = author
  end

  def to_s
    "#{title} by #{author}"
  end

  def ==(other)
    title == other.title && author == other.author
  end
end

lib = Library.new

lib << Book.new('Great Expectations', 'Charles Dickens')
lib << Book.new('Romeo and Juliet', 'William Shakespeare')
lib << Book.new('Ulysses', 'James Joyce')

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Romeo and Juliet by William Shakespeare
  # => Ulysses by James Joyce

lib.checkout_book('Romeo and Juliet', 'William Shakespeare')
  # deletes the Romeo and Juliet Book object from @books and returns it

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Ulysses by James Joyce

lib.checkout_book('The Odyssey', 'Homer')
  # => The library does not have that book
```

## Encapsulation

__What is encapsulation? How does encapsulation relate to the public interface of a class?__

Encapsulation describes how we can separate and hide away different pieces of functionality, making them unavailable to the rest of the code. This allows us to protect that data and define boundaries within our code.

The public interface of a class defines how we interact with the data encapsulated within it's objects. By exposing only certain methods as a means of accessing, manipulating, and utilizing this data we can create objects that separate out _interface_ (public methods available to that object) from _implementation_ (what code those methods actually execute). This allows us as programmers to think on a new level of abstraction.

Not only does encapsulation let us hide the internal representation of an object from the outside, we wan to make sure we only expose the methods and properties that users of the class need. These exposed methods will consist of the public interface.

For example, let's say we have a class `Person` whose objects exhibit the attributes `name` and `age`. But we don't necessarily want to expose the full age of a `Person` object. It's not polite. By employing method access control, we can restrict access to data encapsulated within the object, and expose only what we deem necessary.

```ruby
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def has_a_birthday
    # call private setter method to increment @age within the class
    self.age += 1
  end
  
  def how_old
    # call private getter method for desired output / protect sensitive information
    puts "I am #{age - 3} years old"
  end
  
  def introduce
    # call private getter method to format @name correctly
    puts "Hi my name is #{name.capitalize}"
  end
  
  private
  attr_reader :name
  attr_accessor :age
end

sally = Person.new('sally', 65)

sally.introduce           # => Hi, my name is Sally
sally.has_a_birthday      # => increments @age
sally.how_old             # => I am 63 years old
```

The point of encapsulation is that we get the results we expect from the public interface. As long as this is the case, implementation details don't matter and they can stay _encapsulated_ within the class.

__How do objects encapsulate state?__

Objects encapsulate state in that they contain within themselves various attributes. An attribute consists of an instance variable that references some kind of value (or a collection of values), whether that be a built in Ruby object type (such as a string, array, etc) or a custom defined object of our choosing.

We can call this encapsulation because in the main scope of the program, we can only access these values via getter and setter methods that are defined within the class. There is no way to access the instance variable directly except through the object (direct access must occur in instance methods defined within the class). This is useful because it allow us to set safeguards on data access in order to ensure it is always returned or changed in an appropriate manner.

```ruby
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end

  def how_old
    puts "I am #{age} years old"

  def has_a_birthday
    age += 1
  end

  def name
    name.capitalize
  end

  private

  attr_reader :name
  attr_accessor :age
end

joe = Person.new('joe', 38)

# we can only change age 1 year at a time as is appropriate
joe.has_a_birthday
# no we access @age through an instance method
joe.how_old   # => I am 39 years old

# our name getter method ensures that the value is always formatted appropriately
joe.name      # => 'Joe'
```

__Why should a class have as few public methods as possible?__

A class should have as few public methods as possible because it limits the potential for errors. Further, it makes working with a given class simpler, allowing us to abstract away unnecessary implementation details and focus more easily on the problem or design as a whole. Finally, it protects any encapsulated data from undesired or unnecessary changes.

## Method Access Control

__What is a private method call used for?__

`private` is an access modifier used in a class definition to hide away any implementation details pertaining to the class we want to keep private. Any method defined after the call to `private` within the class will not be available outside of the class. Further, only the single instance of the class in question can call the `private` method, we cannot call them on object that exist outside the object referenced by `self` (within an instance method) even if that object is of the same class.

```ruby
class Person
  def initialize(name)
    @name = name
  end

  # this method will be part of the public interface for Person
  def introduce
    # we can access private methods within the class
    puts "Hi, my name is #{name}"
  end

  private

  # here, we define our @name getter/setter to be private
  attr_accessor :name
end

joe = Person.new("Joe")

# we can call public methods anywhere...
joe.introduce         # => Hi, my name is Joe!

# but the private methods only work inside the class
joe.name              # => NoMethodError: private method `name' called...
```

__What is a protected method call used for?__

`protected` is another access modifier used in class definitions to hide away implementation details pertaining to the class that do not need to be accessed outside the class. `protected` is perhaps best used when overriding and defining custom methods of comparison and equivalence. This is because a method defined after the call to `protected` can be called by all objects of the class, but only from within the class.

This differs from `private` in that a `private` method can only be called by that object which is referenced by `self` within the method. A `protected` method is available to other objects, as long as they are instances of the same class.

```ruby
class Student
  attr_reader :name

  def initialize(name, id)
    @name = name
    @id = id
  end

  def ==(other_student)
    id == other_student.id  # protected methods can be called on other instances
  end

  protected
  attr_reader :id
end

jill1 = Student.new('Jill', 12345)
jill2 = Student.new('Jill', 67890)
jill3 = Student.new('Jill', 12345)

jill1 == jill2              # false
jill1 == jill3              # true
```

## Polymorphism

__What is polymorphism?__

Polymorphism is the ability for objects of a different type to respond to the same method call, as long as the object in question has a compatible method in it's public interface. This means that despite the fact that objects of different classes may have different functionality or implementation, they can still share a common interface (the method that we are calling on them).

A good example of this is the fact that we can perform arithmetic operations in Ruby with both float and integer object types pretty indiscriminantly. Because both object types have a `\` method that takes one argument, we can utilize the same method call on each and get two different results (namely, integer vs float division).

```ruby
[3, 3.0, 5, 5.0].each { |num| puts num / 2 }
  # => 1
  # => 1.5
  # => 2
  # => 2.5
```

Similarly, with regards to different data structures, we can call the `each` method on both an array and a hash, and despite the difference in organization, the method knows how to deal with either one.

```ruby
# the same method call knows how to work with different data structures
[1, 2, 3, 4].each { |num| puts num}
  # => 1
  # => 2
  # => 3
  # => 4
{one: 1, two: 2, three: 3, four: 4}.each { |word, num| puts "#{word} #{num}"}
  # => one 1
  # => two 2
  # => three 3
  # => four 4
```

__Explain two different ways to implement polymorphism.__

Polymorphism can be implemented either through _inheritance_ or through _duck typing_.

Polymorphism through inheritance is implemented whenever an instance of a subclass inherits a more generic method from a superclass, or when a subclass overrides a more generic method from a superclass. This is because in both instances, the object from the subclass is responding to the same method call as an object from the superclass would, regardless of implementation.

```ruby
class Animal
  def eats
    puts "feeds on other living things"
  end
end

class Carnivore < Animal
  def eats
    puts "feeds on meat"
  end
end

class Herbivore < Animal
  def eats
    puts "feeds on plants"
  end
end

class Omnivore < Animal
  # Omnivore subclass inherits Animal#eats
end

monkey = Animal.new
lion = Carnivore.new
rabbit = Herbivore.new
person = Omnivore.new

# all instances, whether from super or sub class, respond to #eats method
animals = [monkey, lion, rabbit, person]
animals.each { |animal| animal.eats }
  # => feeds on other living things
  # => feeds on meat
  # => feeds on plants
  # => feeds on other living things
```

Polymorphism can also be implemented via duck typing, which occurs when different _unrelated_ types of objects respond to the same method call. We can tell when duck typing is in play because it deals with a number of objects that share a common interface, even though they have no relationship via class or module. Duck typing focuses on what an object can _do_ rather than what an object _is_.

```ruby
class School
  attr_reader :staff

  def initialize
    @staff = [Principal.new, Teacher.new, Coach.new]
  end

  def in_session
    staff.each { |worker| worker.work }
  end
end

class Principal
  def work
    puts "I am taking care of administrative tasks"
  end
end

class Teacher
  def work
    puts "I am teaching students"
  end
end

class Coach
  def work
    puts "I am training athletes"
  end
end

School.new.in_session
  # => "I am taking care of administrative tasks"
  # => "I am teaching students"
  # => "I am training athletes"
```

__What is duck typing? How does it relate to polymorphism - what problem does it solve?__

Duck typing occurs when different unrelated types of object respond to the same method call. It is a way for objects to exhibit polymorphism when they do not share methods via either interface or class inheritance. Duck typing is occurring anytime we have a number of different types of objects that all respond to the same interface, even though they are completely unrelated. Duck typing focuses on what an object can _do_ rather than what an object _is_. It gives us a way to informally "type" objects, without necessarily using the formal boundaries imposed by either class or interface inheritance.

(See above for example)

## Inheritance

__What is inheritance?__

Inheritance describes how a class can gain access to either the methods of a superclass or a module. It allows us to define basic classes with general methods that lend themselves to reusability, along with smaller more specific subclasses containing more fine tuned detailed behavior.

Inheritance works either via class inheritance, in which a subclass inherits from a superclass, or via interface inheritance, in which a class gains access to methods defined in a module by mixing that module into the class.

__What is the difference between a superclass and a subclass?__

A superclass is the parent class for a subclass. It contains the more generalized and common behavior for one or more subclasses that may share that behavior.

A subclass is the class that inherits from a superclass. It is usually smaller, defining more fine tuned detailed behavior that would apply to that specific object type.

__When is it good to use inheritance?__

We want to use class inheritance when an "is-a" relationship exists between our different object types. It's a good way to model naturally hierarchal relationships.

For example:

```ruby
class Animal
  def eats
    puts "I am eating"
  end
end

class Dog < Animal; end
class Fish < Animal; end

Dog.new.eats      # => "I am eating"
Fish.new.eats     # => "I am eating"
```

Above, we define the superclass `Animal` as well as two subclasses `Dog` and `Fish`. Class inheritance is appropriate here because a dog _is an_ animal and a fish _is an_ animal. Both classes, therefore, inherit the instance method `Animal#eats`.

We want to use interface inheritance when a "has-a" relationship exists. It's a good way to share behaviors between classes that do not have any sort of hierarchal relationship. By extracting methods that we want to share between classes that don't necessarily have a relationship with each other to a module, and mixing that module into the classes, we can avoid repeating the same method over and over.

```ruby
module Swimmable
  def swim
    puts "I'm swimming"
  end
end

class Animal
  def eats
    puts "I am eating"
  end
end

class Dog < Animal
  include Swimmable
end

class Fish < Animal
  include Swimmable
end

class Cat < Animal; end

Dog.new.swim      # => "I'm swimming"
Fish.new.swim     # => "I'm swimming"
Cat.new.swim      # => NoMethodError
```

Above, we want to give both our `Dog` and `Fish` classes access to the method `swim`, because both a dog and fish have an ability to swim. Not all animals have an ability to swim, however, so we can't place the `swim` method in the `Animal` class for the subclasses to inherit. The solution is to create a module, called `Swimmable`, where we define the method. That way we can mix in this module to any subclass that should exhibit the `swim` behavior, and avoid having to define the `swim` method repetitively in each subclass.

__Give an example of using the super method, both with and without an argument.__

`super` in Ruby is a special keyword that looks up the inheritance chain for a method of the same name and then invokes it.

`super` when called with no explicit arguments will pass along any arguments passed to the method that calls it by default, and attempt to pass those arguments to the method it executes. If the method that is defined earlier in the method lookup chain takes different arguments from that which invokes `super`, you must explicitly call super with those arguments. To ensure that `super` passes no arguments, call it like so: `super()`.

```ruby
class Animal
  def initialize; end
end

class Pet < Animal
  def initialize(name)
    super() # call super with no arguments
    @name = name
  end
end

class Cat < Pet
  def initialize(name, personality)
    super(name) # explicitly pass only `name` argument
    @personality = personality
  end
end

fido = Pet.new("Fido")
felix = Cat.new("Felix", "curious")

p fido    # => #<Pet:0x00005570d77c4d98 @name="Fido">
p felix   # => #<Cat:0x00005570d77c4d20 @name="Felix", @personality="curious">
```

__Give an example of overriding: when would you use it?__

Overriding a method occurs when a class that's closer to the calling object on the method lookup path defines a method of the same name from a class (or module) higher up on the method lookup path. Because Ruby will execute the first method of the name it is searching for, we can define more specific behavior for subclasses that overrides general behavior defined in superclasses.

For example:

```ruby
class Dog
  def speak
    puts "Woof!"
  end
end

class GreatDane < Dog
  def speak
    puts "BOW WOW"
  end
end

class Chihuahua < Dog
  def speak
    puts "arf!arf!arf!"
  end
end

class Beagle < Dog; end

snoopy = Beagle.new
bruce = GreatDane.new
napoleon = Chihuahua.new

snoopy.speak          # => Woof!
bruce.speak           # => BOW WOW
napoleon.speak        # => arf!arf!arf!
```

In the code above, we define the `Dog` superclass with the instance method `#speak` to output `'Woof'`. Then we define the `GreatDane` subclass, which inherites the `#speak` method from `Dog`. However, by defining a new `#speak` method within the class we can override the `'Woof'` output, and replace it with `'BOW WOW'`. Similarly, we override the `#speak` method in the `Chihuahua` subclass, which outputs `'arf!arf!arf!'` when invoked. Finally, the `Beagle` subclass inherits the `#speak` method from `Dog`, and this is not overridden, so we see `'Woof!'` output when it is invoked.

__In inheritance, when would it be good to override a method?__

In Ruby, the `Object` class is the root class from which all other objects inherit. As such, it has a number of methods that are available throughout _all_ other classes, including any custom defined classes we may create. There are certain methods defined within `Object` we want to be careful not to override. These include things like `Object#send`, `Object#is_a?`, `Object#object_id`, etc.

However, there are certain cases where it is both desireable and appropriate to override methods defined in the `Object`
class. This is most commonly done with the `Object#to_s` method, which we can define to create a different string representation of a custom defined object when passed to `puts` or used with string interpolation (both of which call `to_s` implicitly).

Another occasion where we might want to override methods from `Object` is when dealing with methods of equivalence like `==` and comparison like `<=>`. Overriding these methods allows us to tell Ruby _which_ values that are encapsulated within the object we would like to compare, rather than simply asking if it is the same object in memory as another.

__Are class variables accessible to subclasses?__

Class variables are inherited by subclasses. However, it is important to note that all instances of a class _and_ its subclasses share the same copy of the class variable. That means if we access the class variable through one of the subclasses and make any changes to it, this will be reflected when we try to access it through the superclass too.

```ruby
class Shape
  @@sides = nil

  def self.sides
    @@sides
  end
end

class Triangle < Shape
  def initialize
    @@sides = 3
  end
end

class Square < Shape
  def initialize
    @@sides = 4
  end
end

p Shape.sides     # => nil
p Triangle.sides  # => nil
p Square.sides    # => nil

Triangle.new      # sets @@sides to 3

p Shape.sides     # => 3
p Triangle.sides  # => 3
p Square.sides    # => 3

Square.new        # sets @@sides to 4

p Shape.sides     # => 4
p Triangle.sides  # => 4
p Square.sides    # => 4
```

## Modules

__What is a module?__

A module is a special type of container used in interface inheritance. Modules are a good place for us to store common methods that we want to share among different classes that don't necessarily have a hierarchal relationship (as we would see with class inheritance). Though Ruby only allows us to subclass from a single parent class, we can mix in as many modules as we like to a class, so it is a way to avoid repeating certain code logic among classes that may not be related by require common behaviors.

Modules are used for two major purposes: grouping common methods together and namespacing. Unlike a class, a module _cannot_ instantiate an object, so they are concerned mostly with behaviors.

__What is a mixin?__

A mixin module is a module that consists of a grouping of common methods. We can then _mix in_ those methods to a class of our choosing using the keyword `include`.

We want to use mixin module when a "has-a" relationship exists. It's a good way to share behaviors between classes that do not have any sort of hierarchal relationship. By extracting methods that we want to share between classes that don't necessarily have a relationship with each other to a module, and mixing that module into the classes, we can avoid repeating the same method over and over.

```ruby
module Swimmable
  def swim
    puts "I'm swimming"
  end
end

class Animal
  def eats
    puts "I am eating"
  end
end

class Dog < Animal
  include Swimmable
end

class Fish < Animal
  include Swimmable
end

class Cat < Animal; end

Dog.new.swim      # => "I'm swimming"
Fish.new.swim     # => "I'm swimming"
Cat.new.swim      # => NoMethodError
```

Above, we want to give both our `Dog` and `Fish` classes access to the method `swim`, because both a dog and fish have an ability to swim. Not all animals have an ability to swim, however, so we can't place the `swim` method in the `Animal` class for the subclasses to inherit. The solution is to create a module, called `Swimmable`, where we define the method. That way we can mix in this module to any subclass that should exhibit the `swim` behavior, and avoid having to define the `swim` method repetitively in each subclass.

It's important to note that a module cannot instantiate an object, so do not use a mixin for anything that needs to be instantiated.

__What is namespacing?__

Namespacing is essentially an organizing technique, where we use a module to group related or similar classes together. This makes it easier to recognize similarities in our code. Further, because we can use namespace modules to create multiple classes of the same name, it ensures that similarly named classes don't cause problems in highly complex codebases.

When we have classes that are defined in a namespace module, we need to call both the module and class name, separated by the namespace resolution operator, in order to access the methods within.

For example:

```ruby
# namespacing allows us to have multiple classes of the same name
module School
  module EnglishDepartment
    class Teacher
      def teach
        puts "teaches English"
      end
    end
  end
  
  module ScienceDepartment
    class Teacher
      def teach
        puts "teaches Science"
      end
    end
  end
end

School::EnglishDepartment::Teacher.new.teach  # => teaches English
School::ScienceDepartment::Teacher.new.teach  # => teaches Science
```

## Method Lookup Path

__What is the method lookup path?__

The method lookup path describes the order in which classes are inspected when a method is called to see how that method is defined. Ruby starts with the nearest method definitions (such as the specific subclass of the calling object) and moves outward along containers until it finds the method in question. If Ruby never finds the method, it will throw a `NoMethodError`.

```ruby
class Animal
  def characteristics
    "I am multicellular, obtain energy through consuming food, and have nerve cells, muscles, and/or tissues."
  end
end

module Walkable
  def walk
    "I'm walking"
  end
end

module Swimmable
  def swim
    "I'm swimming"
  end
end

class Person < Animal
  include Walkable
  include Swimmable
end

class Cat < Animal
  include Walkable
end

class Fish < Animal
  include Swimmable
end

Cat.ancestors    # => [Cat, Walkable, Animal, Object, Kernel, BasicObject]
Fish.ancestors   # => [Fish, Swimmable, Animal, Object, Kernel, BasicObject]
Person.ancestors # => [Person, Swimmable, Walkable, Animal, Object, Kernel, BasicObject]
```

In the above code, we call the `::ancestors` class method on our defined classes to get an array representing the method lookup path for each. Based on this, we can see that Ruby will first check the closest class to the class or object that invokes the method.

Next, it will check any modules that are included in that class. If more than one module is included, it will check the _last_ included module first. Next, it will check the superclass, then any modules included in the superclass, which are also inherited by the subclass. It will keep moving up along the chain in this order until it reaches `BasicObject` which is the last superclass for all objects in Ruby.

## Constants

__How can we reference a constant initialized within a different class?__

We can access constants referenced within a different class by appending the namespace resolution operator (`::`) to the class name before attempting to reference the constant: `ClassName::CONSTANT`.

__How are constants used in inheritance?__

A constant initialized in a superclass is inherited by the subclass. However, because constants have lexical scope, Ruby will first search the class in which they are referenced, before looking at the inheritance hierarchy. Therefore whenever we reference a constant outside of the class in which it is initialized we should use the syntax where we access it through it's class or module name.

## Getters and Setters

__What is a getter method?__

A getter method is a specifically defined method that returns the value referenced by any given instance variable within an object. We need getter methods to be able to access this value outside of the class. They are generally defined with the same name as the instance variable (i.e. `@name` would have getter method `#name`).

We can either manually define our getter methods like so:

```ruby
def name
  @name
end
```

Or we can use the `attr_*` shorthand provided by Ruby. Both `attr_reader :name` and `attr_accessor :name` provide us with a getter method here.

__What is a setter method?__

A setter method is a specifically defined method that we use to initialize or reassign an instance variable from outside the class or object. Setter methods are usually named with the `=` after the method name. This not only differentiates them from getter methods, but allows us to utilize Ruby's syntactical sugar when invoking them.

```ruby
# defined inside the class
def name=(new_name)
  @name = new_name
end

# call the setter method with syntactical sugar
joe = Person.new('Joe')
joe.name = 'Bob'
```
