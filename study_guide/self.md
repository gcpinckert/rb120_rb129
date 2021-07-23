# Self

`self` is a reserved keyword in Ruby that acts as a variable. This variable always points to the object that "owns" the currently executing code. `self` is a way of being explicit about what our program is referencing and what our intentions are as far as behavior (such as with setter methods vs local variable initialization).

Anytime we have a method that does not have an explicit calling object, Ruby will provide an implicit `self`. For this reason, it is important to understand what `self` is referencing on any given level of code. `self` changes depending on the scope that it is used in.

```ruby
class Person
  attr_reader :name

  def initialize
    @name = name
  end

  def self.scientific_name        # explicit self, self is the class
    'homo sapiens'
  end

  def introduce
    puts "Hi! My name is #{name}"   # implied self.name, self is the object
  end
end
```

## Inside instance methods

Inside of an instance method, `self` points to the object that _calls the method_. Therefore, we can assume that within an instance method `self` will always reference an object that is an instance of that particular class.

```ruby
class Thing
  def calling_object
    self
  end
end

whatever = Thing.new
whatever.calling_object     # => #<Thing:0x0000559c470aa800>
```

Anytime we are using a setter method within an instance method we need to prefix the setter method name with `self`. This is because a setter method takes advantage of Ruby's syntactical sugar and looks just like an assignment statement. Without the `self` caller, Ruby will assume the setter method name is local variable initialization, and we will not be able to modify the desired value of the instance variable in question.

```ruby
# this will not work

class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def change_name(new_name)
    name = new_name
  end
end

bill = Person.new('William')
bill.name                       # => 'William'
bill.change_name('Bill')
bill.name                       # => 'William'
```

In the above code, we define an instance method `change_name` that tries to use the `name=` setter method to reassign the value of `@name`. However, because we are not using the keyword `self` within the instance method, Ruby assumes that we are instead initializing a local variable `name`, to which we assign the string object passed as argument.

When we call `change_name` on the `Person` object `bill` and pass the string `'Bill'` as an argument, this string is assigned to local variable `name` within the method and the instance variable `@name` remains pointing to the string `'William'`. This can be shown when then call the getter method `name` which still returns `'William'`.

```ruby
# this will work
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def change_name(new_name)
    self.name = new_name
  end
end

bill = Person.new('William')
bill.name                       # => 'William'
bill.change_name('Bill')
bill.name                       # => 'Bill'
```

In the above example, we are using `self` to explicitly call the `name=` setter method. This works because `self` references the calling object for the method `change_name`, in this case the `Person` object `bill`. When the code executes then, we really see `bill.name=('Bill')`, which tells Ruby that we are calling the setter method for the instance variable `@name` rather than initializing local variable `@name`.

The success of this can be demonstrated when we use the getter method `name` with `bill` and the return value has indeed changed from `'William'` to `'Bill'`.

## Inside class methods

Within a class method, the calling object is the class itself, therefore `self` will reference the class that calls the method, rather than an instance of that class. This is similar behavior to `self` within an instance method. Because a class in Ruby is really just another kind of object, we've just changed the calling object `self` should reference, not the behavior of `self` itself.

```ruby
class Thing
  def self.calling_object
    self
  end
end

Thing.calling_object          # => Thing
```

Modules are objects as well, so we will see this pattern repeated inside any module methods.

```ruby
module Thing
  def self.calling_object
    self
  end
end

Thing.calling_object            # => Thing
```

## Inside class definitions

Within a class definition, `self` will reference the class (or module) that's in the process of being defined.

```ruby
class Thing
  self == Thing       # => true
end

class OtherThing
  self == OtherThing  # => true
end
```

Because `self` within the class definition references the class itself, we can use this to differentiate class methods from instance methods.

```ruby
class Person
  def initialize(name)
    @name = name
  end

  # instance method
  def introduce
    puts "Hi! My name is #{@name}"
  end

  # class method, because `self` references Person
  def self.scientific_name
    puts 'homo sapiens'
  end
end

Person.scientific_name        # => homo sapiens

joe = Person.new('Joe')
joe.scientific_name           # => NoMethodError
```

In the above code, we define the `Person` class method `::scientific_name`. This is distinguished from an instance method by the use of `self` in the method name. Because `self` within a class definition references the class itself (in this case `Person`), we are telling Ruby explicitly that the calling object for the `scientific_name` method should be a class object. In this case, the class `Person`.

## Inside mixin modules

When you mix in methods from modules using `include`, `self` within those methods will reference the instance that calls the method, just like they would if they were instance methods defined within the class. This allows the mixin to interact with the class it has been mixed into.

```ruby
module Reflection
  def calling_object
    self
  end
end

class Thing
  include Reflection
end

something = Thing.new
something.calling_object
# => #<Thing:0x000055c97b9f6678>
```

In the above code we define the method `calling_object` within the `Reflection` module. This module is then mixed into the `Thing` class. Because `calling_object` will now be treated as an instance method of that class, `self` within it will reference the object that calls the method. In this case, that's the instance `something`.

We can use the keyword `extend` to mix module methods in as _class methods_ instead of _instance methods_. When doing so, `self` within the method will still reference the calling object. However, because the calling object in this case will be the class itself, that's what `self` will reference.

```ruby
module Reflection
  def calling_object
    self
  end
end

class Thing
  include Reflection
end

Thing.calling_object        # => Thing
```

## Outside Any Class

Ruby still provides a reference for `self` if you utilize it outside the scope of any class. It points to `main`, which is an instance of `Object`.

```ruby
puts self.inspect     # => main
```
