# Study Session 8/12/2021

- [Compare FishAliens](#compare-fishaliens)
- [Attack](#attack)
- [Animal Sounds](#animal-sounds)
- [Shopping Basket](#shopping-basket)
- [Player Characters](#player-characters)
- [Dictionary](#dictionary)
- [Library](#library)
- [Constants](#constants)
- [Juniors](#juniors)

## Compare FishAliens

Problem:

```ruby
# Modify the given code to achieve the expected output

class FishAliens
  def initialize(age, name)
    @age = age
    @name = name
  end

  protected

  attr_reader :age, :name
end

class Jellyfish < FishAliens; end

class OctoAlien < FishAliens; end

fish = Jellyfish.new(100, "Fish")
alien = OctoAlien.new(75, "Roger")

                      # Expected output:
p fish == alien       # => false
```

Solution:

```ruby
# Create a comparison to see if the ages of JellyFish and OctoAlien are the same.
class FishAliens
  def initialize(age, name)
    @age = age
    @name = name
  end
  
  def compare_age(other)
    age == other.age
  end
  
  # protected methods that are defined in a superclass are inherited by subclasses and can be invoked but instances of _all_ inheriting subclasses
  
  protected 
  
  attr_reader :age, :name
end

class Jellyfish < FishAliens
  
# if we define protected methods in a subclass, instances from other subclasses cannot access them
  
  def ==(other)
    age == other.age
  end
  
  protected 
  
  attr_reader :age, :name
  
end

class OctoAlien < FishAliens
#   def ==(other)
#     age == other.age
#   end
  
#   protected 
  
#   attr_reader :age, :name
  
end

fish = Jellyfish.new(100, "Fish")
alien = OctoAlien.new(75, "Roger")

p fish == alien      # => returns false when comparison and getters defined in superclass
# raises an error when comparison and getters defined separately in subclasses
```

## Attack

Problem:

```ruby
class Barbarian
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end

class Monster
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end


conan = Barbarian.new("Conan", 50)
zombie = Monster.new("Fred", 100)

conan.attacks
zombie.attacks

# We expected the code to output
#=> "attacks!"
#=> "attacks!"

#=> Instead we raise an error.  What would be the best way to fix this implementation? Why?
```

Solution (plus experimenting with module methods)

```ruby
module Attackable
  def attacks
    puts "attacks!"
  end
  
  def self.roll_attack_dice
    (1..12).to_a.sample
  end
end

class Barbarian
  include Attackable
  
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end

class Monster
  include Attackable
  
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end


conan = Barbarian.new("Conan", 50)
zombie = Monster.new("Fred", 100)

conan.attacks
puts "conan rolls #{Attackable.roll_attack_dice}"
zombie.attacks
puts "zombie rolls #{Attackable.roll_attack_dice}"


# We expected the code to output
#=> "attacks!"
#=> "attacks!"

#=> Instead we raise an error.  What would be the best way to fix this implementation?
```

## Animal Sounds

Problem:

```ruby
# What does the above code output? How can you fix it so we get the desired results?

class Animal
  @@sound = nil
  
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#{@name} says #{@@sound}"
  end
end

class Dog < Animal
  def initialize(name)
    super
    @@sound = 'Woof Woof!'
  end
end

class Cat < Animal
  def initialize(name)
    super
    @@sound = 'Meow!'
  end
end
  
fido = Dog.new('Fido')
felix = Cat.new('Felix')

                    # Expected Output:
fido.speak          # => Fido says Woof Woof!
felix.speak         # => Felix says Meow!
```

Possible solution:

```ruby
class Animal
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#{@name} says #{self.class::SOUND}"
  end
end

class Dog < Animal
  SOUND = 'Woof Woof!'
  
  def initialize(name)
    super
  end
end

class Cat < Animal
  SOUND = 'Meow!'
  def initialize(name)
    super
  end
end
  
fido = Dog.new('Fido')
felix = Cat.new('Felix')

                    # Expected Output:
fido.speak          # => Fido says Woof Woof!
felix.speak         # => Felix says Meow!
```

## Shopping Basket

Problem:

```ruby
# GOAL:
# Create an application that allows you to add "products" to a shopping basket.
# So define the CLASSES for each product (make 3).
# Products should have a name and a price (an integer).
# Add products to the shopping basket
# At checkout calculate total_price of ALL products.

class ShoppingBasket

end

class CheckoutDesk

end

```

Solution:

```ruby
class ShoppingBasket
  attr_reader :cart
  
  def initialize
    @cart = []
  end
  
  def <<(product)
    cart.push(product)
  end

end


class CheckoutDesk
  def calculate_total(shopping_basket)
    total = 0
    shopping_basket.cart.each do |product|
      total += product.price
    end
    total
  end
  
end

class Product
  attr_reader :name, :price
end

class Cheese < Product
  def initialize
    @name = 'Cheese'
    @price = 4
  end
end

class Steak < Product
  def initialize
    @name = 'Steak'
    @price = 15
  end
end

class FrenchFries < Product
  def initialize
    @name = 'French Fries'
    @price = 8
  end
end

cart = ShoppingBasket.new

cart << Cheese.new
cart << Steak.new
cart << FrenchFries.new

clerk = CheckoutDesk.new

p clerk.calculate_total(cart)

# GOAL:
# Create an application that allows you to add "products" to a shopping basket.
# So define the CLASSES for each product (make 3).
# Products should have a name and a price (an integer).
# Add products to the shopping basket
# At checkout calculate total_price of ALL products.
```

## Player Characters

```ruby
# Without running the code, determine what the output will be.

class PlayerCharacter
  attr_reader :name 
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end

class Barbarian < PlayerCharacter
   def initialize(name, hitpoints)
    super(name, hitpoints)
   end

end

class Summoner < PlayerCharacter
  # all Summoners have 100 manapoints
 
  def initialize(name, hitpoints)
    super(name, hitpoints, manapoints)
  end
  
end

conan = Barbarian.new("Conan", 50)
gandolf = Summoner.new("Gandolf", 25)

p conan.rage # true
p gandolf.manapoints # => 100

p gandolf.hitpoints #25
```

Possible solution

```ruby
# Without running the code, determine what the output will be.

class PlayerCharacter
  attr_reader :name, :hitpoints
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end

class Barbarian < PlayerCharacter
  # alternatively to #rage instance method:
  # def initialize(name, hitpoints)
  #   super(name, hitpoints)
  #   @rage = true
  # end
  
  def rage
    true
  end
end

class Summoner < PlayerCharacter
  # all Summoners have 100 manapoints
  
  # MANAPOINTS = 100
  
  attr_reader :manapoints
    
  def initialize(name, hitpoints)
    super(name, hitpoints)
    @manapoints = 100 # or MANAPOINTS (see above)
  end
  
end

conan = Barbarian.new("Conan", 50)
gandolf = Summoner.new("Gandolf", 25)

p conan.rage # true
p gandolf.manapoints # => 100

p gandolf.hitpoints #25
```

## Dictionary

Problem:

```ruby
# Implement the following classes such that we get the desired output

class Dictionary
  def initialize
    @words = []
  end
end

class Word
  def initialize(name, definition)
    @name = name
    @definition = definition
  end
end

apple = Word.new("Apple", "The round fruit of a tree of the rose family")
banana = Word.new("Banana", "A long curved fruit which grows in clusters and has soft pulpy flesh and yellow skin when ripe")
blueberry = Word.new("Blueberry", "The small sweet blue-black edible berry of the blueberry plant")
cherry = Word.new("Cherry", "A small, round stone fruit that is typically bright or dark red")

dictionary = Dictionary.new

dictionary << apple
dictionary << banana
dictionary << cherry
dictionary << blueberry

puts dictionary.words
# Apple
# Banana
# Blueberry
# Cherry

puts dictionary.by_letter("a")
# Apple

puts dictionary.by_letter("B")
# Banana
# Blueberry
```

```ruby
class Dictionary
  attr_reader :words
  
  def initialize
    @words = []
  end
  
  def <<(word)
    words << word
    words.sort!
  end
  
  def by_letter(letter)
    words.select { |word| word.name.start_with?(letter.upcase) }
  end
end

class Word
  include Comparable
  
  attr_reader :name, :definition
  
  def initialize(name, definition)
    @name = name
    @definition = definition
  end
  
  def to_s
    "#{name}"
  end
  
  def <=>(other)
    name <=> other.name
  end
end

apple = Word.new("Apple", "The round fruit of a tree of the rose family")
banana = Word.new("Banana", "A long curved fruit which grows in clusters and has soft pulpy flesh and yellow skin when ripe")
blueberry = Word.new("Blueberry", "The small sweet blue-black edible berry of the blueberry plant")
cherry = Word.new("Cherry", "A small, round stone fruit that is typically bright or dark red")

dictionary = Dictionary.new

dictionary << apple
dictionary << banana
dictionary << cherry
dictionary << blueberry

# notice these should be alphabetical
puts dictionary.words
# Apple
# Banana
# Blueberry
# Cherry

# case insensitive argument
puts dictionary.by_letter("a")
# Apple

puts dictionary.by_letter("B")
# Banana
# Blueberry
```

## Library

```ruby
# Given the two classes defined below, implement the necessary methods to get the expected results.

class Library
  attr_accessor :books

  def initialize
    @books = []
  end

end

class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title = title
    @author = author
  end
end

lib = Library.new

lib << Book.new('Great Expectations', 'Charles Dickens')
lib << Book.new('Romeo and Juliet', 'William Shakespeare')
lib << Book.new('Ulysses', 'James Joyce')

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Romeo and Juliet by William Shakespeare
  # => Ulysses by James Joyce

lib.checkout_book('Romeo and Juliet', 'William Shakespeare')
  # deletes the Romeo and Juliet book object from @books and returns it
  # i.e. returns #<Book:0x0000558ee2ffcf50 @title="Romeo and Juliet", @author="William Shakespeare">

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Ulysses by James Joyce

lib.checkout_book('The Odyssey', 'Homer')
  # => The library does not have that book
```

Possible solution:

```ruby
class Library
  attr_accessor :books

  def initialize
    @books = []
  end

  def <<(book)
    books.push(book)
  end

  def checkout_book(title, author)
    book = Book.new(title, author)
    if books.include?(book)
      books.delete(book_to_checkout)
    else
      puts "The library does not have that book"
    end
  end
end

class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title = title
    @author = author
  end

  def to_s
    "#{title} by #{author}"
  end

  def ==(other)
    title == other.title && author == other.author
  end
end

lib = Library.new

lib << Book.new('Great Expectations', 'Charles Dickens')
lib << Book.new('Romeo and Juliet', 'William Shakespeare')
lib << Book.new('Ulysses', 'James Joyce')

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Romeo and Juliet by William Shakespeare
  # => Ulysses by James Joyce

lib.checkout_book('Romeo and Juliet', 'William Shakespeare')
  # deletes the Romeo and Juliet book object from @books and returns it

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Ulysses by James Joyce

lib.checkout_book('The Odyssey', 'Homer')
  # => The library does not have that book
```

## Constants

Problem:

```ruby
LOCATION = self

class Parent
  LOCATION = self
end

module A
  module B
    LOCATION = self
    module C
      class Child < Parent
        LOCATION = self
        def where_is_the_constant
          LOCATION
        end
      end
    end
  end
end

instance = A::B::C::Child.new
puts instance.where_is_the_constant

# What does the last line of code output?
# Comment out LOCATION in Child, what is output now?
# Comment out LOCATION in Module B, what is output now?
# Comment out LOCATION in Parent, what is output now?
```

```ruby
LOCATION = self # main

class Parent
  LOCATION = self # Parent
end

module A
  module B
    LOCATION = self # module B
    module C
      class Child < Parent
        LOCATION = self # Child
        def where_is_the_constant
          LOCATION # Child
        end
      end
    end
  end
end

instance = A::B::C::Child.new
puts instance.where_is_the_constant

# What does line 40 output?

# Lexical (excluding main scope) -> Inheritance -> Main scope
```

## Juniors

```ruby
# Implement the given classes so that we get the expected results

class ClassLevel
  attr_accessor :level, :members

  def initialize(level)
    @level = level
    @members = []
  end
end

class Student
  attr_acessor :name, :id, :gpa
  
  def initialize(name, id, gpa)
    @name = name
    @is = id
    @gpa = gpa
  end
end

juniors = ClassLevel.new('Juniors')

anna_a = Student.new('Anna', '123-11-123', 3.85)
bob = Student.new('Bob', '555-44-555', 3.23)
chris = Student.new('Chris', '321-99-321', 2.98)
david = Student.new('David', '987-00-987', 3.12)
anna_b = Student.new('Anna', '543-33-543', 3.76)

juniors << anna_a
juniors << bob
juniors << chris
juniors << david
juniors << anna_b

juniors << anna_a
  # => "That student is already added"

puts juniors.members
  # => ===========
  # => Name: Anna
  # => Id: XXX-XX-123
  # => GPA: 3.85
  # => ==========
  # => ...etc (for each student)

p anna_a == anna_b 
  # => false

p david > chris
  # => true

juniors.valedictorian
  # => "Anna has the highest GPA of 3.85"
```

```ruby
class ClassLevel
  attr_reader :level, :members

  def initialize(level)
    @level = level
    @members = []
  end
  
  def <<(student)
    if members.include?(student)
      puts "That student is already added"
    else
      members << student
    end    
  end
  
  def print_members
    members.each do |member|
      puts "=========="
      puts member
    end
  end
  
  def valedictorian
    student = members.max_by(&:gpa)
    puts "#{student.name} has the highest GPA of #{student.gpa}"  
  end
end

class Student
  attr_accessor :name, :gpa, :id
  
  def initialize(name, id, gpa)
    @name = name
    @id = id
    @gpa = gpa
  end
    
  def to_s
    "Name: #{name}\nId: XXX-XX-#{id[-3, 3]}\nGPA: #{gpa}"
  end
  
  def ==(other_student)
    id == other_student.id
  end
  
  def >(other_student)
    gpa > other_student.gpa
  end
end

juniors = ClassLevel.new('Juniors')

anna_a = Student.new('Anna', '123-11-123', 3.85)
bob = Student.new('Bob', '555-44-555', 3.23)
chris = Student.new('Chris', '321-99-321', 2.98)
david = Student.new('David', '987-00-987', 3.12)
anna_b = Student.new('Anna', '543-33-543', 3.76)

juniors << anna_a
juniors << bob
juniors << chris
juniors << david
juniors << anna_b

juniors << anna_a
#   # => "That student is already added"

puts juniors.members
#   # => ==========
#   # => Name: Anna
#   # => Id: XXX-XX-123
#   # => GPA: 3.85
#   # => ==========
#   # => ...etc (for each student)

p anna_a == anna_b 
#   # => false

p david > chris
#   # => true

juniors.valedictorian
#   # => "Anna has the highest GPA of 3.85"
```
