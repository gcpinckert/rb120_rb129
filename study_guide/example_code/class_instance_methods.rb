# What is the difference between instance methods and class methods?

# Instance method:
  # called on the object (the instance of a class)
  # inside, self references calling object (specific instance)
  # has access to instance variables initialized in the calling object
  # has access to any class variables or constants (defined in that class)
  # describes some behavior specific to the particular instance
# Class method:
  # called on the class itself
  # inside, self references the class (still the calling object)
  # has access to class variables and constants (defined in that class)
  # describes some behavior that pertains only to the class as a whole
  # defined with self to distinguish it from an isntance method

  class Dog
    # instance method
    def speak
      puts "Woof"
    end
    
    # class method
    def self.species
      "canis lupis familiaris"
    end
  end
  
  fido = Dog.new
  
  # call an instance method on an object
  fido.speak        # => Woof
  
  # cannot call a class method on an object
  # fido.species      # => NoMethodError
  
  # call a class method on the class
  p Dog.species     # =>  "canis lupis familiaris"
  
  # cannot call an instance method on the class
  # Dog.speak        # => NoMethodError
  