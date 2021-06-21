=begin
- What output does the given code print?
  - The code will print:
    => Fluffy (the return value of the name getter method)
    => My name is FLUFFY (the return value of the overridden to_s method)
    => FLUFFY (the string object assigned to @name, which was mutated by to_s)
    => FLUFFY (the string object assigned to name, mutated by to_s)
- Fix the class so there are no 'surprises'
=end

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

# Further Exploration:
# How does this code produce the result it does?

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

=begin
The above code produces the following:
  => 42, because the integer referenced by local variable name is converted to
    a string and passed to the instance variable @name upon initialization of a
    new Pet object, fluffy
  => My name is 42., because the string object 42 is assigned to the @name
    instance variable, which is accessed by the overriding to_s method in our
    class, and is interpolated into the string which returns the value we see.
    puts automatically calls to_s and outputs it's return value to the console.
  => 42, because the string object 42 is referenced by the instance variable
    @name
  => 43, because the local variable name outside the class, was set to reference
    42, but we increment this value by 1 on line 35. This does not affect @name
=end