# Practice Problems: Easy 3

## Question 1

```ruby
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
```

case 1:

```ruby
hello = Hello.new
hello.hi            # => "Hello"
```

First we initialize a new instance of the class `Hello` and assign it to `hello`. Then we invoke the `Hello#hi` method on `hello`. This invokes the `Greeting#greet` method, which the class `Hello` has access to because it inherits from `Greeting`. `Greeting#greet` outputs the string passed to it as an argument, which in this case is the string `"Hello"`.

case 2:

```ruby
hello = Hello.new
hello.bye           # => NameError
```

First we initialize a new instance of the class `Hello` and assign it to `hello`. Then we invoke the `Goodbye#bye` method on the object `hello`. Because this method is defined in the `Goodbye` class, `hello` does not have access to it, and a `NameError` is thrown.

case 3:

```ruby
hello = Hello.new
hello.greet         # => ArgumentError
```

First we initialize a new instance of the class `Hello` and assign it to `hello`. Then we invoke the `Greeting#greet` method on the object `hello`. However, when we invoke `greet` we do not pass it any arguments. We can see from its definition in the `Greeting` class it expects one argument (the `message` to output), which is why Ruby will throw an `ArgumentError` in this case.

case 4:

```ruby
hello = Hello.new
hello.greet("Goodbye")  # => "Goodbye"
```

First we initialize a new instance of the class `Hello` and assign it to `hello`. Then we invoke the `Greeting#greet` method on the object `hello`, and pass it the string `"Goodbye"` as an argument. `hello` has access to the `Greeting#greet` method through inheritance, so the code will output the string `"Goodbye"`.

case 5:

```ruby
Hello.hi              # => NameError
```

We are invoking the class method `hi` on the class `Hello`. However, `hi` is actually an instance method defined within the class `Hello`. Therefore, this will result in a `NameError` as there is no such class method defined.

## Question 2

From the above code, we can fix the error code received when invoking `Hello.hi` by creating a class method `hi` in the class `Hello`. Class methods are defined with the keyword `self` prefixed to the name of the method. When we do this, we will need to initialize an instance of `Greeting` so that we can call the `greet` method. Because `greet` is an instance method, it must be called on an object, not a class.

```ruby
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  # make `hi` into a class method by adding `self`
  def self.hi
    Greeting.new.greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
```

## Question 3

```ruby
class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end
```

We can create two different instances of the `AngryCat` class by initializing two different `AngryCat` objects and passing them different values as arguments to represent attributes `age` and `name`.

```ruby
spitz = AngryCat.new(4, "Spitz")
tiger = AngryCat.new(7, "Tiger")
```

## Question 4

Change the given class such that when calling `to_s` on an object the result is `I am a tabby cat` where `tabby` is the `@type` of the `Cat` object.

```ruby
class Cat
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{@type} cat"
  end
end
```

We can override the default implementation of the `to_s` method by defining one of our own within the class. Here, we return a string that includes the `@type` attribute of the cat object that calls `to_s`.

```ruby
mewmew = Cat.new('calico')
puts mewmew     # => "I am a calico cat"
# puts calls to_s implicitly
```

## Question 5

```ruby
class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer             # => NameError
tv.model                    # => method executes

Television.manufacturer     # => method executes
Television.model            # => NameError
```

First we initialize a new `Television` Object and assign it to the variable `tv`. Then we try to call the `Television` class method `manufacturer` on the `tv` object. This results in a `NameError`, because `manufacturer` is a class method which must be called on `Television`. The instance method `manufacturer` does not exist.

Next, we call the instance `model` method on the `tv` object. In this case, the `model` method would execute. This is because `model` is an instance method and we call it on the object, so Ruby is able to find the method implementation within the `Television` class.

Next, we call the class method `manufacturer` on the `Television` class. Becaus `manufacturer` is a class method defined within the `Television` class, Ruby is able to find the implementation for this method and the method would execute.

The method call `Television.model` results in a `NameError`. This is because `model` is an instance method, and must be called on an object. `Television` is a class. There is no `model` class method defined, and so Ruby cannot find the method implementation, and throws the error.

## Question 6

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
end
```

We can avoid using the `self` prefix in the `make_one_year_older` method above by referencing the instance variable `age` itself. `self` in this case indicates that we are using the `@age` setter method to increment the instance variable `@age`.

```ruby
def make_one_year_older
  @age += 1
end
```

## Question 7

```ruby
class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end

end
```

In the code above, we have an unnecessary `return` in the class method `information`. Because of Ruby's implied return, the string returned by `information` is returned by the method without an explicit `return` statement.
