=begin
- multiply @age by 2 upon assignment
- multiply @age by 2 again when @age is returned by the getter method

Expected Output: 80
=end

class Person
  def age
    @age * 2
  end

  def age=(a)
    @age = a * 2
  end
end

person1 = Person.new
person1.age = 20
puts person1.age
