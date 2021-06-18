=begin
What is a module? What is its purpose? How do we use them with our classes?
Create a module for the class you created in exercise 1 and include it
properly.

A module is a way in which Ruby can implement polymorphism. It is a collection
of defined methods (behaviors) that can be applied to objects of multiple
types (classes). A module is "mixed in" to a class declaration using the
`include` class method.
=end
module Greet
  def greet(greeting)
    puts greeting
  end
end

class HumanBeing
  include Greet
end

jane = HumanBeing.new
p jane.class
jane.greet("Hey there!")
