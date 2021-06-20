=begin
- Change the code so the value of @phone_number can be read on ln 10 but
cannot be changed on ln 12

Expected Output: 
1234567899
NoMethodError
=end

class Person
  attr_reader :phone_number

  def initialize(number)
    @phone_number = number
  end
end

person1 = Person.new(1234567899)
puts person1.phone_number

person1.phone_number = 9987654321
puts person1.phone_number
