# The given code throws an error. Why? Fix it!

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
puts bob.name
# => Steve

bob.name = "Bob"
puts bob.name
# => Bob

=begin
The code throws an error because we have not defined a setter method for the 
instance variable @name. By using attr_reader rather than attr_accessor, we
have only defined a getter method. Change this to attr_accessor one line 4, and
the code will run
=end