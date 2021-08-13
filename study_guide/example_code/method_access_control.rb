# How do we control access to methods in Ruby?

# Method Access Control is achieved through calls to access modifiers
# Public, Private, Protected are method calls made within the class
  # Public = default, can access inside and outside the class
  # Private = only accessed within the class by calling isntance
  # Protected = only accessed within the class but by an instance of that class (or subclass)

class ContactCard
  attr_reader :name
  
  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end
  
  # we can call private methods inside the class
  def location
    puts "I live on #{address.split[-2, 2].join(' ')}"
  end
  
  private
  
  attr_reader :number, :address
end

bob = ContactCard.new('Bob', '867-5309', '123 Street St')

# by default all instance methods defined within the class are public
# ContactCard#name is public so we can access it outside the class

p bob.name      # => 'Bob'

# private methods cannot be accessed outside the class
# bob.address  # => NoMethodError

# but the public interface may rely on implementing them inside the class to expose certain data/behaviors
bob.location    # => "I live on Street St"

# protected methods may only be called within the class, but can be called by any isntance of the class
class Person
  
  attr_reader :name
  
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  # can call protected methods on both instances here
  def >(other)
    age > other.age
  end
  
  protected
  
  attr_reader :age
end

# protected methods can also be called by an instance of a subclass, as long as the protected method is defined in the superclass
class Child < Person; end

anna = Person.new('Anna', 32)
julie = Person.new('Julie', 29)
charlie = Child.new('Charlie', 4)

p anna > julie    # => true
p julie > charlie # => true
