# Polymorphism and Encapsulation

## Polymorphism

**Polymorphism** is the ability for objects of a different type to respond in different ways to the same method calls (or other messaging). Put another way, polymorphism is how various objects of different classes have different functionality (aka implementation), but these same objects/classes share a _common interface_.

Polymorphism happens when we can call a method without caring about the type of calling object. Basically, when two or more different object types have a method of the same name, we can invoke that method on any of the objects. The results may be the same, or the results may be more specific to that particular object type, but the _message_ we use (the method call) to invoke the behavior is the same, which is the essence of polymorphism.

```ruby
# we can perform arithmetic operations seamlessly on either floats or integers
puts 1 + 1      # => 2
puts 1.2 + 1.2  # => 2.4
puts 1 + 1.2    # => 2.2

# integer division and float division can be called the same way
puts 7 / 2      # => 3
puts 7.0 / 2.0  # => 3.5

# we can create different objects by calling the same method (here ::new)
Hash.new        # => {}
Array.new       # => []
String.new      # => ''

# we can learn things about various object using the same method call
'hello world'.class   # => String
1234.class            # => Integer
['a', 'b', 'c'].class # => Array

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

**client code** = the method we invoke with various object, which only cares that that calling object has a corresponding method that is invoked the same way (i.e with or without arguments, with or without a block).

Polymorphism can be implemented through both [inheritance](./inheritance.md) or [duck typing](#polymorphism-through-duck-typing).

### Polymorphism through Inheritance

Polymorphism through inheritance works in two ways:

1. A specific instance of a subclass inherits a more generic method implementation from a superclass.

2. A subclass overrides a more generic method implementation from a superclass with a different more specific behavior by implementing a method of the same name.

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

class Omnivore < Animal; end

lion = Carnivore.new
rabbit = Herbivore.new
person = Omnivore.new

animals = [lion, rabbit, person]
animals.each { |animal| animal.eats }
  # => feeds on meat
  # => feeds on plants
  # => feeds on other living things
```

In the code above, we define a more general `eats` method in the superclass `Animal` that is available to to all `Animal` objects. In the `Carnivore` subclass, we override this method to implement a process that's more specific to the `Carnivore` type. Similarly, in the `Herbivore` subclass, we override `Animal#eats` for a more specific implementation. However, in the `Omnivore` subclass, no more specific implementation is needed, so we allow it to inherit the generic implementation from `Animal`.

Because we have defined more specific types of `eats`, we can work with all the different types of objects in the same way, even though the implementations may be different. This is shown when we create three objects, `lion` from the `Carnivore` class, `rabbit` from the `Herbivore` class, and `person` from the `Omnivore` class, and place them together in an array. We are able to iterate over each object in the array and invoke the `eats` method on all of them despite the fact that they are all objects of a different type.

This example of is the essence of accessing _different implementations_ through a _common interface_ (in this case, the _client code_ `eats`). When we call `eats` on `lion`, the `Carnivore#eats` method is invoked, and we see the appropriate output `'feeds on meat'`. When we call `eats` on `rabbit` the `Herbivore#eats` method is invoked, and again we see the appropriate output `'feeds on plants'`. Finally, we invoke `eats` on `person` and the inherited `Animal#eats` method is called, which gives us the more generic output of `'feeds on other living things'`.

The above code works because the block `animal.eats` only really cares that each element in the array has an `eats` method that is called with no arguments, which is the case here. The _interface_ (`eats`) is the same for all the objects, despite their different _implementations_.

### Polymorphism through Duck Typing
