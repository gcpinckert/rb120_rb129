=begin
- The code should accept a string containing a first and last name
- The name should be split into two instance variables in the setter
- The name should be joined in the getter method to form a full name

Expected Output: John Doe
=end

class Person
  attr_reader :first_name, :last_name

  def name=(full_name)
    @first_name = full_name.split.first
    @last_name = full_name.split.last
  end

  def name
    "#{first_name} #{last_name}"
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
