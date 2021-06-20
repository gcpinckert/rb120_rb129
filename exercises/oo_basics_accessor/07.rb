=begin
- Add the appropriate accessor methods
- @name should be returned with the added prefix 'Mr.'

Expected Output: Mr. James
=end

class Person
  attr_writer :name

  def name
    "Mr. " + @name
  end
end

person1 = Person.new
person1.name = 'James'
puts person1.name
