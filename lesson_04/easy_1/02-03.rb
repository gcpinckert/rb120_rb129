# Add the ability for the Car and Truck class to go_fast with Speed
# How can you check to see if the Car and Truck can go_fast?

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

# Include module methods with classes by mixing them in with `include`

focus_rs = Car.new
big_semi = Truck.new

# Call the module methods on an instance of the class
focus_rs.go_fast    # => I am a Car and going super fast!
big_semi.go_fast    # => I am a Truck and going super fast!

# We are able to print the type of vehicle from the go_fast method because we
# call the class method on the object within the method, which returns the name
# of the class the object is an instance of. This is available to us through
# the self keyword, which references the object instance within method defs

focus_rs.class  # => Car
big_semi.class  # => Truck
