# Fake Operators and Equality

Lots of operators in Ruby are really method calls using the disguise of Ruby's syntactical sugar to utilize a more visually appealing syntax.

Because they are really methods, we can define our own implementations of them within our custom classes. Doing so overrides the fake operators with our own implementation, so it's important to follow the conventions established for each within the Ruby standard library.

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

## Fake Operators

Ruby's **syntactical sugar** allows us to use more natural expressions with many methods, and this make them look like operators. It's important to know which of these so called "operators" is a _method_ that's acting as a _fake operator_ because these can be custom defined for our custom classes to change their default behavior.

Method | Operator | Description
------ | -------- | -----------
no | `.`, `::` | Method/constant resolution operators
yes | `[]`, `[]=` | Collection element getter and setter method
yes | `**` | Exponential operator
yes | `!`, `~`, `+`, `-` | Not, complement, unary plus and minus (method names for the last two are `+@` and `-@`)
yes | `*`, `/`, `%` | Multiply, divide, and modulo
yes | `+`, `-` | Plus, minus
yes | `>>`, `<<` | Right and left shift
yes | `&` | Bitwise "and"
yes | `^`, `|` | Bitwise exclusive "or" and regular (inclusive) "or"
yes | `<=`, `<`, `>`, `>=` | Less than/equal to, less than, greater than, greater than/equal to
yes | `<=>`, `==`, `===`, `!=`, `=~`, `!~` | Equality and pattern matching (`!=` and `!~` cannot be directly defined)
no | `&&` | Logical "and"
no | `||` | Logical "or"
no | `..`, `...` | Inclusive range, exclusive range
no | `? :` | Ternary if-then-else
no | `=`, `%=`, `+=`, `!=`, `&=`, `>>=`, `<<=`, `*=`, `**=`, `{}` | Assignment (and assignment shortcuts) and block delimiter

Note that overriding fake operators _can_ be dangerous. Since there are so many, we never _really_ know what an expression like `obj1 + obj2` will do.

### Equality Methods

One of the most common fake operators to override is `==`. This also provides us with an `!=` method. See [equivalence](#equivalence).

### Comparison Methods

Implementing our own custom behavior for comparison methods gives us a nice syntax we can use to compare our custom objects. By default, the comparison methods do not know how or what values to compare. We define them to tell them which values we want to compare, again relying on the specific implementations for comparison methods within Ruby's built in classes.

Note that unlike `==` and `!=`, defining `>` does **not** automatically give us `<`. If we want to use both we have to define them both within our class.

```ruby
# this will not work
class Athlete
  attr_accessor :name, :height

  def initialize(name, height)
    @name = name
    @height = height  # height value is in meters
  end
end

shaq = Athlete.new('Shaq', 2.16)
kobe = Athlete.new('Kobe', 1.98)

puts 'shaq is taller than kobe' if shaq > kobe
# => NoMethodError: undefined method '>'
```

In the above code, we define a class `Athlete` whose instances exhibit the attributes `name` and `height`. We then initialize two new `Athlete` objects `shaq` and `kobe`. `shaq` is assigned an `@height` of 2.16 meters during initialization and `kobe` is assigned an `@height` of 1.98 meters during initialization. We then try to compare the two `Athlete` objects with `>` to see which one is taller.

However, we have no defined a `>` method for our `Athlete` class. `>` is in fact an instance method we need to define for the class so Ruby knows which values within the object to compare, and not an operator as it might appear.

```ruby
# this will work
class Athlete
  attr_accessor :name, :height

  def initialize(name, height)
    @name = name
    @height = height  # height value is in meters
  end
  
  def >(other_athlete)
    height > other_athlete.height # relies on float#>
  end
end

shaq = Athlete.new('Shaq', 2.16)
kobe = Athlete.new('Kobe', 1.98)

puts 'shaq is taller than kobe' if shaq > kobe
# => 'shaq is taller than kobe'
```

In the above code, we define a custom `>` that tells Ruby what values to compare within our `Athlete` objects. In this case, it's the value referenced by the instance variable `@height`. We rely on the `Float#>` method to implement our custom `Athlete#>` method. Then when we call `Athlete#>` on the `shaq` object and pass it the `kobe` object as an argument, Ruby executes the `Athlete#>` implementation, which compares the `@height` of each object. In this case, `shaq` has a greater height than `kobe` so `'shaq is taller than kobe'` is output.

Note that the above does not automatically generate an `Athlete#<` method. If we wish to utilize this, we'll need to define it individually, which we can do quickly like so:

```ruby
def <(other_athlete)
  !self.>(other_athlete)
end
```

### Right and Left Shift

When implementing fake operators choose functionality that makes sense when used with the operator-like syntax that you are defining.

For example, custom defining an `<<` or `>>` method can provide a good interface when working with an object that represents a collection. For a class that describes a collection like this, we can even utilize some kind of guard clause withing our `<<` implementation to reject adding items unless some criteria is met.

```ruby
class GradeLevel
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(student)
    # guard clause, assume we have a Student#passed_previous_grade? defined
    # return unless student.passed_previous_grade?
    members.push student
  end
end

# define Student class for collaborator objects
class Student
  attr_accessor :name, :gpa

  def initialize(name, gpa)
    @name = name
    @gpa = gpa
  end
end

juniors = GradeLevel.new('Juniors')
sophia = Student.new('Sophia', 3.75)
jim = Student.new('Jim', 3.04)
arnold = Student.new('Arnold', 2.99)

juniors << sophia
juniors << arnold
juniors << jim

p juniors.members
# => [#<Student:0x000056194369c190 @name="Sophia", @gpa=3.75>, #<Student:0x000056194369c0f0 @name="Arnold", @gpa=2.99>, #<Student:0x000056194369c140 @name="Jim", @gpa=3.04>]
```

In the above code, we define two classes. A `GradeLevel` class, which is a collection of `Student` collaborator objects, represented by the instance variable `@members` which points to an empty array upon initialization. We define a custom left shift method `<<`, which allows us to add `Student` collaborator objects to the `@members` array using Ruby's syntactical sugar. We rely on the `Array#push` method for implementation so that we can mirror the pattern set forward by Ruby's buit in object's behavior with `<<`.

This is shown to operate the way we want when we instantiate a new `GradeLevel` object, `juniors` and add the three `Student` objects `sophia`, `jim`, and `arnold` to it. We can see by inspecting the `members` attribute for our `juniors` grade level that it now consists of an array of three `Student` objects.

### The Plus Method

Though somewhat unintuitive, `+` and other arithmetic operators are actually methods and not operators at all. This means that we can also custom define arithmetic operations for our custom classes. As with `<<` we'll want to try and keep our implementation within the pattern of behavior that is set up by the built in Ruby classes for `+`.

In this case, we notice that `+` should be either _incrementing_ or _concatenating_ the calling object with an argument. Let us also notice that `+` returns a value _of the same class_ of the calling object and the argument passed to it. This means that we don't necessarily want to to return the value we get from whatever `#+` method we utilize in our implementation, we want to initialize a new object of the class we are defining to represent our incremented or concatenated value.

```ruby
class GradeLevel
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(student)
    members.push student
  end

  def +(other_grade)
    result_group = GradeLevel.new('New Group')
    # Use Array#+ to change the @members of the new grade to return
    result_group.members = members + other_grade.members
    result_group
  end
end

class Student
  attr_accessor :name, :gpa

  def initialize(name, gpa)
    @name = name
    @gpa = gpa
  end
end

juniors = GradeLevel.new('Juniors')
juniors << Student.new('Sophia', 3.75)
juniors << Student.new('Jim', 3.04)
juniors << Student.new('Arnold', 2.99)

seniors = GradeLevel.new('Seniors')
seniors << Student.new('Barbara', 3.88)
seniors << Student.new('Margaret', 3.65)
seniors << Student.new('Charles', 3.25)

upperclassmen = juniors + seniors
p upperclassmen
# => #<GradeLevel:0x000055b7df29ec48 @name="New Group", @members=[#<Student:0x000055b7df29eea0 @name="Sophia", @gpa=3.75>, #<Student:0x000055b7df29ee50 @name="Jim", @gpa=3.04>, #<Student:0x000055b7df29ee00 @name="Arnold", @gpa=2.99>, #<Student:0x000055b7df29ed38 @name="Barbara", @gpa=3.88>, #<Student:0x000055b7df29ece8 @name="Margaret", @gpa=3.65>, #<Student:0x000055b7df29ec98 @name="Charles", @gpa=3.25>]>
```

The code above relies on the same classes `GradeLevel` and `Student` from above. We further define a custom `GradeLevel#+` method so that we can combine two `GradeLevel` instances according to the pattern set up by `+` in the Ruby docs. Our implementation of `GradeLevel#+` initializes a new `GradeLevel` object to return, this will hold all the members of both the calling `GradeLevel` object, `juniors` and the argument passed, the `GradeLevel` object `seniors`.

We then utilize the `members` getter method to access the arrays of students that represent the members of each `GradeLevel` object, and use `Array#+` to concatenate both. Returning the newly generated `GradeLevel` object allows us to complete implementation, and now when we call `+` on a `GradeLevel` instance, we will get a new `GradeLevel` value returned. This can be shown when we output the result of `upperclassmen.inspect` (with `p`), which prints a string representation of the new `GradeLevel` objects, whose instance variable `@members` now points to an array containing all the `Student` objects from the `juniors` `GradeLevel` object and the `seniors` `GradeLevel` object.

### Element Setters and Getters

If we are working with a class that represents a collection, we can also custom define element getter and setter methods. This allows us to take advantage of Ruby's syntactical sugar with regards to element reference and reassignment.

Actual Method Call | Syntactical Sugar
------------------ | -----------------
`array.[](2)` | `array[2]`
`array.[]=(4, 'fifth element')` | `array[4] = 'fifth element'`

In our `GradeLevel` example class, we have defined instance variable `@members` as an array of collaborating `Student` objects. Therefore, we can define custom element setter and getter methods for `@members` that allow us to modify the collection via Ruby's syntactical sugar. Our implementation will rely on `Array#[]` and `Array#[]=`.

```ruby
class GradeLevel
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(student)
    members.push student
  end

  def +(other_grade)
    result_group = GradeLevel.new('New Group')
    result_group.members = members + other_grade.members
    result_group
  end

  def [](index)
    # return the element from @members at the specified index
    members[index]
  end

  def []=(index, object)
    # reassign the element from @members at the specified index to the object passed as argument
    members[index] = object
  end
end

class Student
  attr_accessor :name, :gpa

  def initialize(name, gpa)
    @name = name
    @gpa = gpa
  end
end

juniors = GradeLevel.new('Juniors')
juniors << Student.new('Sophia', 3.75)
juniors << Student.new('Jim', 3.04)
juniors << Student.new('Arnold', 2.99)

juniors[2]      # => #<Student:0x00005584601cbe40 @name="Arnold", @gpa=2.99>

juniors[2] = Student.new('Bianca', 3.89)
juniors[2]      # => #<Student:0x00005584601cbc88 @name="Bianca", @gpa=3.89>
```
