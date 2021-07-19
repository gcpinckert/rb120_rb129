# Inheritance

**Inheritance** describes how a class can inherit the behaviors of a superclass, or parent class. This allows us to define basic classes with _large reusability_ and smaller _subclasses_ for more fine-tuned detailed behaviors.

**Superclass** = the parent class for a subclass. Contains the more common behaviors for a set of subclasses that may share that behavior.

**Subclass** = the class that inherits from a superclass. In Ruby, all classes are in fact subclasses of the `BasicObject` class.

## Class Inheritance

We can use the `<` symbol with a class name to cause a class definition to inherit from any given superclass.

```ruby
class Dog
  def speak
    puts "Woof!"
  end
end

class Poodle < Dog; end
class Collie < Dog; end
class Beagle < Dog; end

# all the Dog subclasses inherit behavior from the Dog superclass
snoopy = Beagle.new     # => Woof!
fluffy = Poodle.new     # => Woof!
lassie = Collie.new     # => Woof!

snoopy.speak
fluffly.speak
lassie.speak
```

We can define our own custom methods within a subclass to **override** any inherited methods of the same name. Ruby looks for method definitions from the closest possible area on outward. Therefore, it will encounter any method's defined in the subclass first, and execute the implementation it finds there. If the method name in question is not found, it will continue to look upwards in the chain of superclasses until it finds what it is looking for.

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
