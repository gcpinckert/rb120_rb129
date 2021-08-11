# Study Session 8/11/2021

## Common Bugs to Look Out For Debugging

- Is the Module included?
  
- Is self prepended to the setter method invocation?

- Using `super` wrong?
  - (passing in the amount of needed arguments for the called method via `super`)
  - super
  - super(param, param2)
  - super()

- Does the class have the specified method that was invoked?
  - (trying to call an instance method on the `Array` class for example)

- Trying to call a `private` method
  - raises the `private` method error

- `uninitialized` instance variable
  - reference `nil`

- subclass overriding desired behavior, does the subclass inherit what it should?

- Are we accessing the constant correctly?
  - via the namespace operator (ClassName::CONSTANT)

- Changing the value of a class variable from a subclass

## What are modules? When is it appropriate to use them?

- Modules let you implement multiple inheritance rather than single inheritance

```ruby
module Players
  class Barbarian
    def attack
      # rolls dice to determine move
      "attacks with a sword"
    end
  end
  
  class Wizard
    def cast_spell
    end
  end
  
end

module Enemies
  class Barbarian
    def attack
      # randomly generated attack 
      "attacks with a spear"
    end
  end

  class Wizard
  end
end
```

## How does inheritance work in Ruby? When would inheritance be appropriate?

- Class inheritance
- Interface inheritance
- Overriding in subclasses
- Modules with subclasses
- Do instance variables get inherited?
- How do uninitialized instance variables get accessed by subclasses?

## What is polymorphism in Ruby? How do we implement it in code?

- different objects respond to a common interface
- What is a common interface?
- Implemented through inheritance
  - Demonstrate class inheritance
  - Demonstrate interface inheritance
- Duck typing

---

```ruby
p 'hello'.class
p 123.class
p [1, 2, 3].class

# inheritance

module Huntable
  def hunts
    "I hunt for prey"
  end
end

class Animal
  def eat
    "I eat food"
  end
end

class Herbivore < Animal
  def eat
    "I eat plants"
  end
end

class Carnivore < Animal
  include Huntable
  
  def eat
    "I eat meat"
  end
end

class Omnivore < Animal
  include Huntable
end

rabbit = Herbivore.new
lion = Carnivore.new
person = Omnivore.new

[rabbit, lion, person].each do |animal|
  puts animal.eat
end

p lion.hunts
p person.hunts

# ducktyping

class SportsGame
  def play_game(attendees)
    attendees.each(&:attend)
  end
end

class Athlete
  def attend
    puts "Shoots! Scores!"
  end
end

class Fan
  def attend
    puts "Go! Go Team!"
  end
end

class Coach
  def attend
    puts "Hustle! Hustle!"
  end
end

class Cheerleader
  def attend
    puts "Ra! Ra! Ra!"
  end
end

SportsGame.new.play_game([Athlete.new, Fan.new, Coach.new, Cheerleader.new])
```

## How is Method Access Control implemented in Ruby? Provide examples of when we would use public, protected, and private access modifiers

- One way that Ruby implements encapsulation within OOP
- Restricts certain and data and functionality within the class
- A private method is only available to its class and its instance
- Protected method is available within the class but only to objects that are instances of that class

## What is the relationship between classes and objects in Ruby?

```ruby
class ContactCard
  attr_reader :name, :number, :address
  
  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end
  
  def call
    puts "calling #{number}..."
  end
  
  def navigate
    puts "navigating to #{address}..."
  end
end

joe = ContactCard.new('Joe', '867-5309', '1234 Street Ave')
p joe
sally = ContactCard.new('Sally', '555-5555', '6789 Avenue Blvd')
p sally

joe.call
sally.call

joe.navigate
sally.navigate
```

State =
  all together @name, @number, @address and their values
  any unitialized instance variabls
  state would be nothing if there were no instance variables initialized

Attributes =
  name:
    @name
    value assigned to the instance variable
    (any getter and setter methods that pertain to this)

## What is abstraction in Ruby? What does it mean in the context of OOP?

Abstraction refers to the ability of programming languages to create compound elements that can be named and manipulated as units.

These tend to be based on real world models, which allows us to think on a higher level in our problem solving.

```ruby
class ContactCard
  attr_reader :name, :number, :address
  
  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end
  
  def call
    puts "calling #{number}..."
  end
  
  def navigate
    puts "navigate to #{address}..."
  end
  
  def to_s
    puts "========"
    puts "#{name}"
    puts "#{number}"
    puts "#{address}"
    puts "========"
  end
end

class Phone
  attr_reader :contacts
  
  def initialize
    @contacts = []
  end
  
  def add_contact(contact)
    @contacts << contact
  end
  
  def display
    contacts.each { |contact| puts contact }
  end
end

anna = ContactCard.new("Anna", "555-5555", "123 Street Blvd")

my_phone = Phone.new
my_phone.add_contact(anna)
my_phone.display

my_phone.contacts.first.call
```

## Why is it generally safer to invoke a setter method (if available) vs. referencing the instance variable directly when trying to set an instance variable within the class? Give an example

```ruby
class BankAccount
  attr_reader :balance
  
  def initialize(balance)
    @balance = balance
  end
  
  def balance=(new_balance)
    if new_balance < 0
      puts "Error"
    else
      @balance = new_balance
    end
  end
  
  def deposit(amount)
    self.balance = (amount + balance)
  end
  
  def withdrawl(amount)
    self.balance = (balance - amount)
  end
end

savings_account = BankAccount.new(500)
savings_account.withdrawl(600)
p savings_account.balance
```

## What are modules?

Modules are a container that allows us to mix in methods with as many classes as we like

```ruby
# mixin modules (multiple inheritance)
module Solvable
  def solving_equations
    "I am solving equations"
  end
end

module Learnable
  def learn
    "I am learning"
  end
end

class Student
  include Learnable
end

class MathMajor < Student
  include Solvable
end

class ScienceMajor < Student
  include Solvable
end

class EnglishMajor < Student
  
end

class Teacher
  include Learnable
end

class Machine
  include Learnable
end

puts MathMajor.new.learn
puts Teacher.new.learn

# we cannot instantiate objects from a module
  
# Use modules to group together classes as in namespacing

module School
  module HistoryDepartment
    class Teacher
      def teaches
        puts "I am teaching history."
      end
    end
  end
  
  module MathDepartment
    class Teacher
      def teaches
        puts "I am teaching math."
      end
    end
  end
end

School::HistoryDepartment::Teacher.new.teaches
School::MathDepartment::Teacher.new.teaches

# Define "module methods" that don't fit in anywhere else

module School
  def self.math
    2 + 2
  end
end

p School.math
```

## What does it mean to say an object encapsulates its state?

```ruby
class Person
  attr_reader :name
  
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def tell_polite_age
    puts "I am #{age - 5} years old."
  end
  
  def >(other)
    age > other.age
  end
  
  protected
  
  attr_reader :age
end

class Dog
  def initialize(age)
    @age = age
  end
  
  protected
  
  attr_reader :age
end

ginni = Person.new('Ginni', 33)
luke = Person.new('Luke', 23)
snoopy = Dog.new(50)

puts ginni > snoopy # raises error
```
