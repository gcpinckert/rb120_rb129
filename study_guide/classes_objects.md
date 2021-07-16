# Classes and Objects

## Objects

In Ruby, anything that has a **value** can be considered an **object**. Basically, things like numbers, strings, arrays, classes, and modules. Methods, blocks, and variables _are not objects_.

```ruby
# objects
'hello'.is_a?(Object)                   # => true
1.is_a?(Object)                         # => true
['one', 2, :three, nil].is_a?(Object)   # => true
Hash.new.is_a?(Object)                  # => true

module Describe
  def what_am_i
    puts "I am an object."
  end
end

class Thing
  include Describe
end

Describe.is_a?(Object)                  # => true
Thing.is_a?(Object)                     # => true
thing = Thing.new
thing.is_a?(Object)                     # => true
thing.what_am_i                         # => "I am an object"
```

Objects are created from **classes** (which are also another type of Object).

**Class** = a mold
**Object** = something created from that mold

Individual objects can contain different information, but can still be instances of the same class.

```ruby
string1 = "I am a string object"
string2 = "A different string object"

puts string1.class      # => String
puts string2.class      # => String
puts string1            # => "I am a string object"
puts string2            # => "A different string object"
```

## Classes

A **class** is the basic outline of **attributes** and **behaviors** belonging to a particular kind of object. Attributes represent the **state** of an object, such as the different values and data that make up that individual object. Behaviors describe what objects of that class should be able to do, that is the **methods** they can invoke.

Use a **class definition** to define a custom class. These are constructed with the keywords `class`...`end`. Class names use the CamelCase naming convention (they are technically constants so it's important to capitalize them). Files that contain your custom class definition should be named with snake_case and reflect their contents.

```ruby
class Person
  # initialization behavior for class instance (object)
  def initialize(name, age)
    @name = name              # name attribute for class instance (object)
    @age = age                # age attribute for class instance (object)
  end

  # appropriate behavior for class instance (object)
  def introduce
    puts "Hello, my name is #{@name}"
  end
end

# Creates a new instance of Person and stores it in a variable
ginni = Person.new('Ginni', 33)
ginni.introduce     # => "Hello, my name is Ginni"
```

Within a class, we define [instance variables](#instance-variables) to keep track of the different attributes of each object that is created. [Instance methods](#instance-methods) expose the behavior available to _all_ objects of a class.

Below, we create two different Fish objects. They both have an instance variable `@type`, and each points to a different value. In the case of `nemo` it references the string `'clownfish'` and in the case of `bruce` it references the string `'shark'`. However, both fish objects have access to the behavior defined by the instance method `#swim`. When we invoke `#swim` on any given `Fish` instance, it will display that object's attribute `@type`.

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

Use the `.class` method to return the class name of any object.

```ruby
'string'.class      # => String
4.class             # => Integer
[1, 2, 3].class     # => Array
nil.class           # => NilClass
true.class          # => TrueClass

# using Person class from above
bob = Person.new('Bob', 42)
bob.class           # => Person
```

## Initializing a New Object

Creating a new object or instance from a class is known as **instantiation**. We instantiate an object from a class by calling the class method `::new`. This invokes the `#initialize` instance method for the calling class, which defines the behavior we want to execute when a new object is initialized.

```ruby
Hash.new                    # => {}
String.new                  # => ''

# Person#initialize is defined to take an argument
class Person
  def initialize(name)
    @name = name
  end

  def introduce
    puts "Hi my name is #{@name}"
  end
end

# When we call Person::new, we must pass the argument #initialize expects
joe = Person.new('Joe')   # => #<Person:0x0000563bc80e9250 @name="Joe">
joe.introduce             # => "Hi, my name is Joe"

# Or we can define initialize to supply a default argument
class Person
  def initialize(name='John Doe')
    @name = name
  end

  def introduce
    puts "Hi my name is #{@name}"
  end
end

# No argument is supplied but the default value is assigned to @name
anon = Person.new         # => #<Person:0x000055e2d01e8968 @name="John Doe">
anon.introduce            # => "Hi, my name is John Doe"
```

The `#initialize` instance method that gets invoked each time we create a new object is known as a **constructor**, because it is triggered upon creating and it helps us create that new object in the desired way.

We can put any kind of code within the `#initialize` method that we want, but it's best to keep it to what is strictly necessary for the object's construction.

```ruby
class Thing
  def initialize
    puts "A Thing has been initialized!"
  end
end

Thing.new       # => A Thing has been initialized!
```

## Instance Variables

**Instance variables** are used to tie data to an individual object. They track the individual attributes and states for that specific instance of a class. They are useful for tracking the unique state of particular objects, outside of any commonalities gained from shared class.

We differentiate instance variables by adding an `@` to the beginning of their name.

In the code below, we initialize two new `Person` objects and assign them to the variables `jack` and `jill`. When the objects are initialized, we pass each the string `'Jill'` and `'Jack'` respectively. `'Jill'` is assigned to the `@name` instance variable for the `Person` object referenced by `jill` and `'Jack'` is assigned to the `@name` instance variable for the `Person` object referenced by `jack`. This is demonstrated when we call the `#introduce` method on both objects, and each individual `@name` value is output.

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

Because instance variables track individual object state, they are scoped at the object level. That is, they _cannot_ cross over between different objects, but they _are_ available throughout the instance methods for any particular object.

This basically means that for any given object, you can access an instance variable within an instance method _without passing it in_, even if it was initialized outside of that particular instance method.

Looking at the example above, we can see this demonstrated by the fact that the `#introduce` method has access to the `@name` value for both `jack` and `jill`, despite the fact that we never pass it into the method and it is initialized in the constructor method for `Person`.

This works across all instance methods, as long as we are dealing with the same particular instance that the instance variable describes.

```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def speak
    puts "#{@name} says woof!"
  end

  def sit
    puts "#{@name} sits!"
  end

  def down
    puts "#{@name} lays down!"
  end

  def beg
    puts "#{@name} wants to eat your food! bark! bark!"
  end
end

# instantiate new Dog object sparky, assigns 'Sparky' to @name
sparky = Dog.new('Sparky')
sparky.speak                  # => Sparky says woof!
sparky.sit                    # => Sparky sits!
sparky.down                   # => Sparky lays down!
sparky.beg                    # => Sparky wants to eat your food! bark bark!
# notice how all instance methods have access to @name for sparky
```

Instance variables are available within instance methods _even if they are not initialized_, because their scope is at the object level. Namely, even if an instance variable has not been initialized, it will be recognized as a variable and Ruby will treat it as if it references a value of `nil`. This means that you can reference uninitialized instance variables without having the program throw a `NameError`.

```ruby
class Cat
  def initialize(name)
    @name = name
    @personality
  end

  def assign_personality
    @personality = ['friendly', 'grouchy', 'curious'].sample
  end

  def speak
    case @personality
    when 'friendly' then puts 'purrrr'
    when 'grouchy'  then puts 'hisssss'
    when 'curious'  then puts 'meow???'
    else                 puts 'meow'
    end
  end
end

fluffy = Cat.new('Fluffy')
# => #<Cat:0x000055e2d0232248 @name="Fluffy">

fluffy.speak        # => meow

fluffy.assign_personality
fluffy
# => #<Cat:0x000055e2d0232248 @name="Fluffy", @personality="friendly">


fluffy.speak        # => purrrr
```

In the above code, we define the `Cat` class such that the instance variable `@personality` is not initialized until we call the `#assign_personality` instance method. Therefore, when we instantiate a new `Cat` object and assign it to the variable `fluffy`, it will not contain a value for `@personality` as show with the object returned by `::new`.

We might expect that calling the instance method `#speak` would result in a `NameError` being thrown, since it relies on the value references by `@personality` to determine its output. However, when we run the code, no `NameError` will be thrown. Rather, referencing the uninitialized `@personality` returns a `nil` value. When the case statement is evaluated, the `else` will execute and we see the output of `meow`.

We then invoke the `#assign_personality` instance method, which assigns a value selected at random from an array to `@personality`. We can see by examining the `fluffy` object that `@personality` now references a value of `'friendly`. Calling the `#speak` method again, we see the output of `'purrrr'` showing that the value referenced by `@personality` has indeed changed.

## Instance Methods
