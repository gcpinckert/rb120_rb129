# Modules

A **module** is a special type of container used in [interface inheritance](./inheritance.md#interface-inheritance). Modules are generally used to store behaviors we want available in some, but not all, subclasses. It is a way to avoid repeating certain code logic that doesn't make sense to pass along in a formal hierarchy as with class inheritance.

A module _cannot instantiate an object_. Only a class can have an instance. Therefore, modules are only used for **namespacing** and **grouping common methods together**.

## Mixin Modules

Ruby exhibits _single inheritance_, that is, a class can only directly subclass from one superclass. Because of this, sometimes there are methods we need defined that don't really fit into our formal class inheritance structure. The answer to this is the _mixin module_. Though a subclass can only inherit from a single parent, it can mix in as many modules as it likes.

```ruby
module Speakable
  def speak(sound)
    puts sound
  end
end

class Animal
  def eats
    puts "eats food"
  end
end

class Fish < Animal; end

class Person < Animal
  include Speak
end

class Cat < Animal
  include Speak
end

felix = Cat.new
bob = Person.new
nemo = Fish.new

# all objects have access to Animal#eats through class inheritance
felix.eats          # => "eats food"
bob.eats            # => "eats food"
nemo.eats           # => "eats food"

# not all animals speak, but some do, so we mixin a module
felix.speak('meow') # => "meow"
bob.speak('hello')  # => "hello"
nemo.speak('glub')  # => NoMethodError: undefined method `speak'
```

In the above code example, we have the superclass `Animal` with the instance method `eats` defined within, because all animals eat. We then have the subclasses `Person`, `Cat` and `Fish`. Not all of these animals have the capacity to "speak", so it would not be appropriate to put a `#speak` method into the `Animal` class.

We avoid having to define `#speak` twice in both `Person` and `Cat` by extracting the repeated logic to the `Speakable` module and mixing it in. Using the `include` keyword here allows our `Person` and `Cat` class to inherit all the methods defined within `Speakable` via [interface inheritance](./inheritance.md#interface-inheritance).

When should we use a mix in module?

- Ask what the relationship is:
  - If there's an **is-a** relationship (as in "A Cat is an Animal") use class inheritance.
  - If there's a **has-a** relationship (as in "A Person has the ability to speak") use a mixin module.
- Use mixin modules to group methods together that multiple unrelated classes will have to access.
- Do not use a module for anything that needs to be instantiated.

## Namespacing

**Namespacing** consists of organizing similar classes under a module, or using a module to group related classes. Doing so makes it easier to recognize related classes in our code. It also reduces the likelihood of classes colliding with other similarly names classes in our codebase.

To work with classes and objects that are namespaced in a module, we have to call the classes in the module with the following syntax `ModuleName::ClassName.new`.

```ruby
module Animal
  class Fish
    attr_reader :fins, :gills

    def initialize
      @fins = true
      @gills = true
    end
  end

  class Mammal
    attr_reader :warm_blooded, :fur

    def initialize
      @warm_blooded = true
      @fur = true
    end
  end

  class Reptile
    attr_reader :cold_blooded, :scales

    def initialize
      @cold_blooded = true
      @scales = true
    end
  end
end

salmon = Animal::Fish.new
bear = Animal::Mammal.new
snake = Animal::Reptile.new

p salmon.fins             # => true
p bear.fur                # => true
p snake.cold_blooded      # => true
```

In the above code example, we use the `Animals` module to categorize the related classes `Fish`, `Mammal`, and `Reptile`. We can still instantiate new objects by access the classes through the module by using the **namespace resolution operator** `::`. Each class defines it's own distinctive attributes, which we can still access on the object level, that is, through the created instance of each given class.

Namespacing also makes it possible for us to repeat more common class names without interfering with the rest of our codebase. This is done by implementing a hierarchal structure within out namespace, by using a combination of class definitions and lower level namespacing within the overall namespace.

```ruby
# main overall namespace
module RegionalFauna

  # lower level namespace module
  module SouthAmerica
    # repeated class name
    class Monkey
      attr_reader :prehensile_tail
      
      def initialize
        @prehensile_tail = true
      end
    end
  end
  
  # lower level namespace module
  module Africa
    # repeated class name
    class Monkey
      attr_reader :prehensile_tail
      
      def initialize
        @prehensile_tail = false
      end
    end
  end
end

spider_monkey = RegionalFauna::SouthAmerica::Monkey.new
baboon = RegionalFauna::Africa::Monkey.new

p spider_monkey.prehensile_tail       # => true
p baboon.prehensile_tail              # => false
```

In the above code, we are able to define two classes both named `Monkey` due to using hierarchal namespacing. The instances of each class can exhibit distinct attributes appropriate to the class. For example, here the `Monkey` instance which is defined in the `SouthAmerica` lower level namespace will return `true` when we call the getter method `prehensile_tail`. However, the `Monkey` instance which is defined in the `Africa` lower level namespace will return `false` when we call the getter method `prehensile_tail`.

## Module Methods

We can define **module methods** that can be called directly on the module similarly to the way we define [class methods](./classes_objects.md#class-methods). When defining the method within the module, we add the keyword `self` to the front of the method name, which functions as a placeholder to represent the calling module.

These kinds of methods are particularly useful when you have methods that seem out of place or don't really fit nicely anywhere in your code.

We call module methods directly from the module, similarly to the way we would call a class method.

```ruby
# namespace module example 1 from above, code omitted for brevity
module Animal
  def self.out_of_place_method(num)
    num ** 2
  end
end

Animal.out_of_place_method(4)     # => 16
```
