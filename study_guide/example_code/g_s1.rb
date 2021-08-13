# What are getter and setter methods in Ruby? How do we create them?

# Accessor methods give us access to the values referenced by instance variables
  # Instance variables are encapsulated within objects
  # We need methods to access and reassign their values
  # A getter method returns the value referenced by the instance variable of that name
  # A setter method reassigns the value reference by the instance variable of that name
  # Manually defined getters and setters
  # attr_* shorthand
  # Using getters and setters inside the class
  # Using getters and setters outside the class

  class Alien
    def initialize(name, planet)
      @name = name
      @planet = planet
    end
    
    # without getters and setters we can only expose information by access the instance variables directly
    def who
      puts "I am #{@name} from #{@planet}"
    end
  end
  
  marty = Alien.new('Marty', 'Mars')
  
  # the object encapsulates the data assigned to instance variables at initialization
  p marty
    # => #<Alien:0x0000562a8980e3c8 @name="Marty", @planet="Mars">
  
  # we cannot access that data outside the class without defining methods
  # marty.name    # => NoMethodError
  # marty.planet  # => NoMethodError
  marty.who       # => I am Marty from Mars
  
  
  class Person
    # we can access the @name value but not reassign it
    attr_reader :name
    
    # we can both access and reassign the @number value
    attr_accessor :number
    
    # we can only reassign @address, not access it
    attr_writer :address
    
    def initialize(name, number, address)
      @name = name
      @number = number
      @address = address
    end
    
    # we can define a method that exposes on the information we want public
    def location
      # and call a private getter method within
      puts "I live on #{address.split[1]} street."
    end
    
    private
    
    attr_reader :address
  end
  
  bob = Person.new('Bob', '867-5309', '123 Street St')
  
  # we only have a getter defined for @name, the setter raises an error
  puts bob.name        # => Bob
  # bob.name = 'Sue'   # => NoMethodError
  
  # a setter and getter is defined for @number
  puts bob.number          # => 867-5309
  bob.number = '555-5555'
  puts bob.number          # => 555-5555
  
  # only a setter method is defined for @address, the getter is private
  # bob.address            # => NoMethodError (private)
  
  # but we do have another method that exposes information we want public
  bob.location             # => I live on Street street.
  # and we can change the value referenced by @address
  bob.address = '321 Avenue Blvd'
  bob.location             # => I live on Avenue street.
  