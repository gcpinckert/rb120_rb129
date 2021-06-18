=begin
- Create a class named Person
- Include an instance variable @secret
- Use setter method to add a value to @secret
- Use a getter method to print @secret
=end

class Person
  attr_accessor :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
puts person1.secret
  # -> Shh.. this is a secret!
