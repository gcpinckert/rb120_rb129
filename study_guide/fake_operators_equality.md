# Fake Operators and Equality

## Equivalence

**Equivalence** is the idea of equality. Because `==` in Ruby is in fact a method and not an operator, we can define custom ideas of equality for our custom objects.

Many of the built in Ruby object classes already have custom definitions that determines what we are checking for when we check for equality.

```ruby
a = 'hello world'
b = 'hello world'

# checks to see if they are the same object in memory
a.equal?(b)     # => false

# checks to see if they reference identical values
a == b          # => true
```

### ==

The `==` method has a special syntax to make it look like a normal operator that is part of Ruby's syntactical sugar. It is not, however, an operator, but an instance method. We can, therefore, assume that the value used for comparison of each calling instance is determined by its class.

The original `==` is defined in `BasicObject`, from which all other class in Ruby descend. Therefore, all classes have a `==` available to them. But many classes define their own `==` which overrides the superclass method and specifies the unique value each class should use for comparison.

By default, the `==` method will check to see if the two objects being compared are the same object in memory (just like the `equal?` method shown above). In order to check unique values for equality in our custom defined classes, we need to override this `==` implementation from `BasicObject`.

```ruby
# Using the default `==` method
class Student
  attr_reader :name, :id

  def initialize(name, id)
    @name = name
    @id = id
  end
end

joe_1 = Student.new('Joe', 12345)
joe_2 = Student.new('Joe', 12345)

joe_1 == joe_2
```
