=begin
# Given the following code
bob = Person.new
bob.hi

# And the error message
NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
from (irb):8
from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'

What is the problem and how do you fix it?

The problem is that we are trying to call a private method outside the class.
We can fix this by having a public method that calls the private one,
allowing us to display the return value of the private method when we call the
public one outside the class. Alternatively, we can simply make the private
method 'hi' public.
=end

# Option 1

class Person
  def display_hi
    puts "#{hi}"
  end

  private

  def hi
    'Hi'
  end
end

bob = Person.new
bob.display_hi
  # -> 'Hi'

# Option 2

class Person
  def hi
    puts 'Hi'
  end
end

bob = Person.new
bob.hi
  # -> 'Hi'
