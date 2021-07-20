# Method Access Control

**Method access control** is implemented through the use of _access modifiers_ that restrict access to methods within a class. In Ruby, this is accomplished with the `public`, `private`, and `protected` access modifiers

## Public

A public method is one that is available to anyone who knows either the class or object name. It is readily available for use throughout the program, whether inside or outside of the class.

A class's **interface** consists only of it's public methods. This describes how other classes and objects interact with this class and its instances.

```ruby
# a method defined within a class is public by default
class Person
  # a public getter and setter method
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def introduce
    puts "Hi, my name is #{name}!"
  end
end

joe = Person.new('Joe')

# we can call public methods anywhere within the program
joe.name                  # => Joe
joe.introduce             # => Hi, my name is Joe!
```

## Private

Private methods are those that work _within the class_ but are not available in the rest of the program. They are _only_ accessible from other methods within the class.

Private methods are defined with the `private` method call within a class. Anything that comes after the invocation of `private` will be considered a private method.

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

In the code above, we define the `Person` class such that the setter and getter methods for `@name` are private. We also provide the public instance method `#introduce` as the interface for being able to access the value stored in `@name` outside the class.

When we initialize a new `Person` object, `joe`, we can only access the value stored within `@name` through the `#introduce` method. Any call to the `name` getter outside the class will result in a `NoMethodError`. We are still able to invoke the `name` getter method within the class, however, as can be seen in the implementation of the `#introduce` method.

## Protected

Protected methods are those that are available within the _class_ as opposed to only being available within an _instance of the class_. For practical purposes, this means that they can be invoked by all objects within a certain class, but only from within the class.

This differs from `private` methods in that a private method can only be called by the singular instance within the class. We can use `protected` methods to compare objects of a particular class, which is their most common use.

```ruby
# this will not work
class Student
  attr_reader :name

  def initialize(name, id)
    @name = name
    @id = id
  end

  def ==(other_student)
    id == other_student.id  # #id is private so cannot be called by another instance
  end

  private
  attr_reader :id
end

jill1 = Student.new('Jill', 12345)
jill2 = Student.new('Jill', 67890)
jill1 == jill2                        # => NoMethodError: private method `id'...

# this will work
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
jill1 == jill2              # false
jill1 == jill1              # true
```
