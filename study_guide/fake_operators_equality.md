# Fake Operators and Equality

## Equivalence

**Equivalence** is the idea of equality. Because `==` in Ruby is in fact a _method_ and not an operator, we can define custom ideas of equality for our custom objects.

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

The original `==` is defined in `BasicObject`, from which all other class in Ruby descend. Therefore, all classes have a `==` method available to them. But many classes define their own `==` method which overrides the superclass method and specifies the unique value each class should use for comparison.

By default, the `==` method will check to see if the two objects being compared are the same object in memory (just like the `equal?` method shown above). In order to check unique values for equality in our custom defined classes, we need to override the `==` implementation from `BasicObject`.

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

joe_1 == joe_2                          # => false
```

In the above code, we define the class `Student` such that it's instances exhibit the attributes `name` and `id`. Then we initialize two `Student` objects and assign identical values to both attributes. However, when we invoke the `==` method on the instance referenced by `joe_1`, the implementation of `==` is still that of `BasicObject`. `==` is comparing the two objects to see if they are the _same object in memory_. `joe_1` and `joe_2` reference two separate objects so `==` returns `false`.

```ruby
# custom defined == method
class Student
  attr_reader :name, :id

  def initialize(name, id)
    @name = name
    @id = id
  end

  def ==(other_student)
    id == other_student.id
  end
end

joe_1 = Student.new('Joe', 12345)
joe_2 = Student.new('Joe', 12345)

joe_1 == joe_2                          # => true
```

In the above code, In the above code, we define the class `Student` such that it's instances exhibit the attributes `name` and `id`. Then we initialize two `Student` objects and assign identical values to both attributes. However, `Student` also has a custom `==` method defined which overrides the inherited behavior from `BasicObject`. In this case, we are using `Integer#==` to compare the `id` values from two instances of `Student`. `joe_1` and `joe_2` have identical `id` values, so the `Student#==` method will return `true`.

We can define our custom `==` methods in whatever way makes the most sense for the object in question. In this case, we choose to compare `id` numbers as two students of the same name may not be the same student. However, a unique id number is assigned to each student enrolled so that is what we choose to asses for finding equivalence.

Note that almost every core class in Ruby has their own implementation for `==`. We can rely on these implementations as well when defining out own `==`.

When you define a custom `==` method, it automatically assumes the same implementation for `!=`. That means that given the `Student` class example above, the following will also work:

```ruby
bob_1 = Student.new('Bob', 67890)
joe_1 != bob_1                        # => true
```

### equal? and object_id

The `equal?` method is a method used to determine whether two variables not only have the same value, but whether they reference the same object.

```ruby
a = 'hello world'
b = 'hello world'
a == b                # => true
a.equal? b            # => false

a = [1, 2, 3, 4]
b = [1, 2, 3, 4]
a == b                # => true
a.equal? b            # => false
```

Be careful not to override this method by creating your own custom `equal?`. It's much better to implement a custom `==` method as described above instead.

You can also compare two object's object ids to get the same result as using `equal?`.

Every object has a method called `object_id` that returns a unique identifying number for that object. This method is a good way to determine if two variables are pointing to the same object, or if they merely hold identical values. Two different variables that are pointing to the same object will both return the same number. That number is _completely unique_ so if the variable in question references a different object, `object_id` will return a different number entirely.

```ruby
# strings
str1 = 'something'
str2 = 'something'

p str1.object_id                      # => 60 <or some randomly generated num>
p str2.object_id                      # => 80 <or some randomly generated num>

p str1.object_id == str2.object_id    # => false
puts 

# arrays
arr1 = [1, 2, 3]
arr2 = [1, 2, 3]

p arr1.object_id == arr2.object_id    # => false
puts 

# symbols
sym1 = :something
sym2 = :something

p sym1.object_id == sym2.object_id    # => true
puts

# integers
int1 = 5
int2 = 5
p int1.object_id == int2.object_id    # => true
```

In the above code, we initialize two string objects and compare their distinct object ids'. The object id for `str1` is different from that of `str2` so they are two separate objects in memory. Similarly for the two initialized array objects `arr1` and `arr2`.

Then we compare two symbol object `sym1` and `sym2`, which are apparently the same object in memory, despite us initializing the two symbols `:something`. Similarly, `int1` and `int2` both reference the same object in memory, the integer `5`.

This is because both symbols and integers are **immutable objects**. Though it may look like we are initializing more than one symbol or integer, in reality this is not the case. In Ruby, immutable objects that have the same value actually represent _the same object in memory_. Therefore, there is only ever one symbol `:something` or integer `5`. Any assignment statements that involve it will cause the variable to reference the same object in memory.

### ===

The `===` method is an instance method that is used implicitly with case statements. When `===` compares two objects it's really asking, _if the calling object is a group, does the object passed as an argument belong in that group?_.

```ruby
a = 'hello'
b = 'hello'
a === b         # => true
# essentially asking does ['hello'] include 'hello'?

a = 1
b = 1
a === b         # => true
# essentially asking does [1] include 1?

a = 'words'
String === a    # => true
# does the String class include 'words'?

b = 5
(1..9) == b     # => true
# does the Range (1..9) include 5?

String === b    # => false
# does the String class include 5?
```

Behind the scenes, a case statement is using `===` to compare the value in the `when` clause with the value declared by `case`.

```ruby
num = 42

case num
when (1..25)    then puts 'first quarter'
when (26..50)   then puts 'second quarter'
when (51..75)   then puts 'third quarter'
when (76..100)  then puts 'last quarter'
else            puts 'not in range'
end

# => second quarter
```

Note that defining a custom behavior for `===` is not often necessary, because using a custom class in a case statement is pretty unusual.

### eql?

The `eql?` method determines if two objects contain the sam value and if they are of the same class. It's used most frequently by hashes to determine equality among it's members (because keys must be unique). It's not used very often.