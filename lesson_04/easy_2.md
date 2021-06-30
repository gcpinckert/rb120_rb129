# Practice Problems: Easy 2

## Question 1

Given the following code:

```ruby
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end
```

What is the result of executing the following code?

```ruby
oracle = Oracle.new
oracle.predict_the_future
```

First we initialize a new instance of the Oracle class and assign this object to the local variable `oracle`. Then we call the `Oracle` instance method `predict_the_future` on `oracle`. This method concatenates the string `"You Will"` with a string selected at random from the `choices` instance method. The outcome will therefore be, some string reading either: `"You will eat a nice lunch"`, `"You will take a nap soon"`, or `"You will stay at work late"`.

## Question 2

```ruby
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end
```

What is the result of the following?

```ruby
trip = RoadTrip.new
trip.predict_the_future
```

First we initialize a new instance of the `RoadTrip` class and assign this object to the local variable `trip`. Then we call the `Oracle#predict_the_future` instance method on this object. Because `RoadTrip` inherits from `Oracle`, it has access to `predict_the_future`. However, when the method is called, and it invokes the instance method `choices`, the `RoadTrip#choices` method is executed instead of `Oracle#choices`. This is because the `RoadTrip` class is lower in the Ruby method lookup chain, and overrides methods of the same name in the parent class.

## Question 3

```ruby
module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end
```

Ruby will look for a method by going up something called the method lookup chain. This can be seen by calling the `ancestors` class method on a particular class. `ancestors` returns an array in which each element is the next class or module on the method lookup chain for a particular class. It must be called on the class itself.

```ruby
HotSauce.ancestors  # => [HotSauce, Taste, Object, Kernel, BasicObject]
Orange.ancestors    # => [Orange, Taste, Object, Kernel, BasicObject]
```

## Question 4

```ruby
class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end
```

In the above code, the method `type` is a getter method for the instance variable `@type`, and the method `type=` is a setter method for the instance variable `@type`. We can condense these manual method definitions into the Ruby shorthand for getters and setters, which is `attr_accessor :type`.

Further, in the `describe_type` method, we are referencing `@type` directly. We should change this to invoking a getter method for cleaner more maintainable code.

```ruby
class BeesWax
  # creates getter and setter method for instance variable @type
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def describe_type
    # don't reference instance variables directly, but use their getter method
    puts "I am a #{type} of Bees Wax"
  end
end
```

## Question 5

- `excited_dog = "excited dog"`
  - a local variable
  - all lower case, snake_case formatting, no symbols prepending variable name
  - obeys all scoping boundaries
- `@excited_dog = "excited dog"`
  - an instance variable
  - prepended with an @ at the beginning of the variable name
  - scoped at the object level
- `@@excited_dog = "excited dog"`
  - a class variable
  - preprended with @@ at the beginning of the variable name
  - scoped at the class level

## Question 6

```ruby
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end
```

The class method is `self.manufacturer`. This is because class methods are defined with the special keyword `self` in their name. In method names, `self` refers to the class, which must call the method when invoked.

```ruby
Television.manufacturer   # calls class method manufacturer
```

## Question 7

```ruby
class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end
```

`@@cats_count` is a class variable. It tracks states or attributes that pertain to the class itself. In this case, `@@cats_count` is tracking the number of `Cat` objects that have been initialized. We can see in the `initialize` instance method that it's value is incremented by one for every `Cat` object that we create. We can check to see if this is working with the following code:

```ruby
Cat.cats_count                # => 0, check initial value
mewmew = Cat.new('calico')    # create new Cat object
Cat.cats_count                # => 1, value has incremented by 1
```

## Question 8

```ruby
class Game
  def play
    "Start the game!"
  end
end

class Bingo
  def rules_of_play
    #rules of play
  end
end
```

Add the expression `< Game` to ensure that the `Bingo` class inherits the `play` method from the `Game` class.

```ruby
class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
```

## Question 9

```ruby
class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
```

If we add a `play` instance method to the `Bingo` class it would override the `play` method from the `Game` class. This means that whatever implementation we define in the `Bingo#play` method would execute, rather than the implementation from `Game#play`. This is because the `Bingo` class is lower on the method lookup chain than `Game`, so its `play` method is encountered first.

```ruby
class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def play
    "Let's play Bingo!"
  end

  def rules_of_play
    #rules of play
  end
end

Bingo.new.play      # => "Let's play Bingo"
```

## Question 10

Some benefits to Object Oriented Programming include:

The ability to pass around data in a more efficient way. Because we can store object states in instance variables that are available through the object itself, we have the ability to access important information without creating a huge amount of interdependencies by passing around variables as arguments. Everywhere we can access the object, we can access the data that is relevant to it.

The ability to design general behaviors (methods) that can be inherited by more specific subclasses allows us to have more maintainable code. Because we have the ability to assign these behaviors to many different classes, changes have to be made in fewer places.

Further, these specific subclasses, when necessary, can override the inherited behaviors with their own specific implementation.

By encapsulating both methods and data in containers like Objects and Classes, we expose less functionality, which allows us to write safer code.

Conceptually, it gives us another layer of abstraction, allowing us to wrap specific implementation details in a mental model that's easier to understand.
