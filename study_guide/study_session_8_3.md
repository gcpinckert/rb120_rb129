# Study Session with Alonso - 8/3/2021

## What do we mean by abstraction in an OOP context?

In OOP an abstraction refers to the way we can separate our implementation from our interface. Everything in Ruby is an object, and each class for those objects proceeds us with a number of methods (the interface) that allows us to work with and manipulate that particular date. We don't necessarily care about _how_ those methods are implemented, just that they give us the results we want. The fact that we don't have to think about how these methods are implemented, gives us another layer of abstraction away from the inner workings of the code and computer, which helps us focus more on the higher level of how to solve the problem.

For example:

```ruby
string = 'hello world'
p string.upcase # => HELLO WORLD
p string.reverse # => dlrow olleh
```

The above code gives us new string objects that have been manipulated by the methods, but we don't need to know about how these methods give us these return values. We're concerned with the bigger picture.

Further, in OOP modeling real world concepts using custom classes and objects allows us to engage in the kind of metaphorical thinking that makes it easier to model larger and more complex problems and programs.

For example, when modeling a complex problem, we can start from smaller building blocks and work our way up. In the case of building the 21 program, we need Card objects and a Deck object that manipulates them. However, once we build out the implementation and interface for our cards, we can pretty much forget about the details in how they work, and rely on the methods we've built for them to implement our perhaps more complex Deck methods. Not worrying about how the cards are working, and taking them at _face value_ allows us to focus fully on the Deck problems, giving us more flexibility in how we might approach the solution.

The benefits of abstraction are mainly, cleaner more organized less dependant code that's easier to maintain and to think about.

## Debugging Problem

```ruby
module Temperatures
  ROOM = 70
end

module Heatable
  INCREMENT = 10

  def heat
    self.temperature += INCREMENT
  end

  def hot?
    temperature > self.class::ROOM
  end
end

class Sandwich
  include Temperatures
  
  attr_reader :toppings
  attr_accessor :temperature
  
  def initialize
    @toppings = []
    @temperature = ROOM
  end
  
  def add_topping(topping)
    toppings << topping
  end
  
  #   def to_s    
  #   "#{hot? ? 'Heated' : 'Not heated'} #{self.class.to_s.downcase} with toppings: #{topings.join(' & ')}"
  # end
  
  def to_s
    string_result = ''
    string_result += 'Heated' if hot?
    string_result << " #{self.class.to_s.downcase}"
    if toppings.size > 0
      string_result << " with toppings: "
      string_result << " #{toppings.join(' & ')}"
    end
    
    string_result
  end
end

class Hotdog < Sandwich
  include Heatable

  def initialize
    super
  end

  def make_footlong
    @footlong = true
  end

  def footlong?
    @footlong
  end
end

my_hotdog = Hotdog.new
my_hotdog.add_topping('ketchup')
my_hotdog.add_topping('mustard')
my_hotdog.make_footlong
my_hotdog.heat

# Make changes to the above code to achieve the expected output below.
# Do not modify existing classes or modules

puts my_hotdog # Heated hotdog with toppings: ketchup & mustard

# if the hotdog is heated, add 'heated' to the beginning
# get the class name as a string and downcase it
# if the toppings array is not empty:
  # join all items in the array with ' & ' and add to 'with toppings: '
  ```
