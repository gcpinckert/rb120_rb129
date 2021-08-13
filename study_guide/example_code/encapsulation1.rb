# What is encapsulation in Ruby, and why does it matter? Demonstrate with code.

# Encapsulation = hiding different pieces of functionality and within modular "blocks" of code
  # Objects encapsulate data
  # Classes can encapsulate behavior - separation of interface and implementation
  # Method Access Control
  # Allows us to base problem model on real world paradigms
  # Another level of abstraction, we can use public interface without worrying about implementation
  # Another level of abstraction, build "modular" programs

class Person
  attr_accessor :name
  attr_reader :birthday
  
  def initialize(name, age, birthday)
    @name = name
    @age = age
    @birthday = birthday
  end
  
  # custom setter method manipulates data appropriately
  def has_a_birthday
    self.age += 1
  end
  
  # custom getter method exposes only the desired data
  def how_old
    puts "I am #{age - 5} years old"
  end
  
  def to_s
    "#{name} : #{birthday}"
  end
  
  private
  
  attr_accessor :age
end

class BirthdayTracker
  attr_reader :people
  
  def initialize
    @people = []
  end
  
  def <<(person)
    people << person
  end
  
  def show_birthdays
    people.each { |person| puts person }
  end
end

bob = Person.new('Bob', 35, 'Jan 1')

# The attributes name and number are encapsulated within Bob
p bob
  # => #<Person:0x0000559e3a68a5c8 @name="Bob", @number="867-5309">

# We can access these values using getter & setter methods
p bob.name              # => "Bob"
bob.name = "Sue"
p bob.name              # => "Sue"
bob.name = "Bob"

# We can restrict access to sensitive data using method access control
# (via access modifier `private`)
# Rely on public interface to ensure data is manipulated and exposed appropriately
bob.how_old
bob.has_a_birthday
bob.how_old

my_pals = BirthdayTracker.new

my_pals << bob

# The my_pals object now encapsulates person object bob
p my_pals
  # => #<BirthdayTracker:0x00005607d39f8ce8 @people=[#<Person:0x00005607d39f9120 @name="Sue", @age=36, @birthday="Jan 1">]>

# BirthdayTracker can interact with collaborator Person objects using public interface, we are not concerted with implementation
my_pals.show_birthdays
  # => Bob : Jan 1
  # Any changes to Person#to_s method do not affect BirthdayTracker#show_birthdays method
