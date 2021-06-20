=begin
- Add the appropriate accessor methods
- @name should be capitalizes upon assignment

Expected Output: Elizabeth
=end

class Person
  attr_reader :name

  def name=(n)
    @name = n.capitalize
  end
end

person1 = Person.new
person1.name = 'eLiZaBeTh'
puts person1.name
