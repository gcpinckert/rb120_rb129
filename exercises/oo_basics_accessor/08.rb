=begin
- The code allows @name to be modified from outside the method
- It mutates the value referenced by @name
- Return only a copy of @name instead of a reference to it

Expected Output: James
=end

class Person
  def name
    @name.dup
  end

  def initialize(name)
    @name = name
  end
end

person1 = Person.new('James')
person1.name.reverse!
puts person1.name
