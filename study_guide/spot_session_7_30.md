# SPOT Session 7/30/2021

In the `make_one_year_older` method we have used `self`. What is another way we could write this method so we don't have to use the `self` prefix? Which use case would be preferred according to best practices in Ruby, and why?

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
  
  def self.name 
    puts "I am #{self}"
  end
end
```

---

What module/method could we add to the above code snippet to output the desired output on the last 2 lines, and why?

```ruby
class House
  attr_reader :price

  def initialize(price)
    @price = price
  end

  def <(other)
    price < other.price
  end

  def >(other)
    !(self < other)
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```

You don't always have to define custom comparison operators. All you have to do is include the module `Comparable` and define a `<=>` operator for the methods within `Comparable` to use.

```ruby
class House
  include Comparable

  attr_reader :price

  def initialize(price)
    @price = price
  end

  def <=>(other)
    price <=> other.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2 # => Home 1 is cheaper
puts "Home 2 is more expensive" if home2 > home1 # => Home 2 is more expensive
```

---

What is output and returned, and why? What would we need to change so that the last line outputs `”Sir Gallant is speaking.”`?

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

What is super? The difference between super and super()?

---

Do `molly` and `max` have the same states and behaviors in the code above? Explain why or why not, and what this demonstrates about objects in Ruby.

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

Anything in the `Cat` class is going to have the same behaviors. However, even if we were to put the same identical name for two `Cat` objects, they would still be separate states because they belong to two separate instances of `Cat`.

---

What are the scopes of each of the different variables in the above code?

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

Define _lexical scope_

---

The following is a short description of an application that lets a customer place an order for a meal:

- A meal always has three meal items: a burger, a side, and drink.
- For each meal item, the customer must choose an option.
- The application must compute the total cost of the order.

1. Identify the nouns and verbs we need in order to model our classes and methods.
2. Create an outline in code (a spike) of the structure of this application.
3. Place methods in the appropriate classes to correspond with various verbs.

```ruby
class MealItem
end

class Burger < MealItem #cost
end

class Side < MealItem
end

class Drink < MealItem
end

class Order
  def initialize
    @options = []
  end
  
  def calc_total
  end
end
```
