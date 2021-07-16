# Accessor Methods

## What are setters and getters?

**Accessor Methods** are special methods used with [instance variables](./classes_objects.md#instance-variables) that allow us to **get** or **set** the data contained within the state of an object.

## Getter Methods

Outside of the class, we need a specially defined method to access the values stored within the instance variables associated with an object. We can define this method within the class, so that we can retrieve the value in question wherever the object is accessible.

```ruby
# this will not work
class Person
  def initialize(name)
    @name = name
  end
end

jack = Person.new('Jack')
jack.name
# => NoMethodError: undefined method 'name'

# this will work
class Person
  def initialize(name)
    @name = name
  end

  def name      # technically, we can call this method anything
    @name
  end
end

jack = Person.new('Jack')
jack.name
# => 'Jack'
```

In the code above, we define the `Person` class such that an instance of `Person` contains the attribute `@name`. In the first example, there is no getter method defined, so when we call `jack.name` on our `Person` object, we get a `NoMethodError`.

The second example defines the instance method `#name` which returns the value referenced by the instance variable `@name`. We can call this method anything we want (`show_name`, `get_name`, etc), but by convention it's best to use the name of the instance variable you want to return.

This method returns the value associated with `@name` for the individual object that calls it. In this case, that's the string `'Jack'`, which is returned by the invocation `jack.name`.

Getter methods like these can also be used within the class. In fact, it's better to access the value of an instance variable through a getter method than using the instance variable directly. This makes for more flexible and easy to maintain code (because changes need only to be made where the getter method is defined).

When using getter methods within the class, simply drop the `@` at the beginning of the instance variable (this is why we call getter methods by the same name as the attribute). Calling a method without an explicit caller causes Ruby to set the default caller to `self`. As long as you are scoped on the object level (i.e. within an instance method), this will refer to the object, meaning we can call the getter method name on its own.

```ruby
class Person
  def initialize(n)
    @name = n                       # initialize @name
  end

  def name                          # define getter method name
    @name
  end

  def introduce
    puts "Hi, my name is #{name}!"  # access @name through getter method #name
  end
end

ginni = Person.new('Ginni')
ginni.name                          # => 'Ginni'
ginni.introduce                     # => 'Hi, my name is Ginni!'
```

## Setter Methods

Setter methods allow us to initialize and reassign attributes for a particular object, i.e. change the data stored within an instance variable. They are defined similarly to getter methods, but they include _reassignment_ within the method definition. Because of this, we name them with the `=` after the method name, which disambiguates them from our getter methods, as well as allows us to take advantage of Ruby's _syntactical sugar_.

```ruby
class Person
  def initialize(n)
    @name = name        # initialize @name
  end

  def name              # define getter method #name
    @name
  end

  def name=(n)          # define setter method #name=
    @name = n
  end

  def introduce
    puts "Hi, my name is #{name}!"
  end
end

jim_bob = Person.new('Jim')
jim_bob.name                    # => 'Jim'
jim_bob.introduce               # => 'Hi, my name is Jim!'

# call #name=() with Ruby's syntactical sugar
jim_bob.name = 'Bob'
jim_bob.introduce               # => "Hi, my name is Bob!'
```

Setter methods, like getter methods, can be called from within the class. However, because they use the syntax of `#method_name = argument`, we must distinguish them somehow from local variable initialization. To do this, we call them with the keyword `self`.

```ruby
# this will not work
class Contact
  attr_accessor :name, :number

  def intialize(name, number)
    @name = name
    @number = number
  end

  def change_number(n)
    number = n                  # Ruby thinks we are initializing local variable
  end
end

jenny = Contact.new('Jenny', '555-5555')
jenny.number                    # => 555-5555

jenny.change_number('867-5309')
jenny.number                    # => 555-5555

# this will work
# this will not work
class Contact
  attr_accessor :name, :number

  def intialize(name, number)
    @name = name
    @number = number
  end

  def change_number(n)
    self.number = n                  # call setter method using self.
  end
end

jenny = Contact.new('Jenny', '555-5555')
jenny.number                    # => 555-5555

jenny.change_number('867-5309')
jenny.number                    # => 867-5309
```
