=begin
- Add the appropriate accessor methods
- @age should only be visible to instances of Person

Expected Output: false
=end

class Person
  attr_writer :age

  def older_than?(other)
    age > other.age
  end

  protected
  attr_reader :age
end

person1 = Person.new
person1.age = 17

person2 = Person.new
person2.age = 26

puts person1.older_than?(person2)
