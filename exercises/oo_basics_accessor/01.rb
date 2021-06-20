=begin
- Add the appropriate accessor methods to the given code

Expected Output: Jessica
=end

class Person
  attr_accessor :name
end

person1 = Person.new
person1.name = 'Jessica'
puts person1.name
