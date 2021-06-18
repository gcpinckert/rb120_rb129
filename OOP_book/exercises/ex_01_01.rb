# Create an object in Ruby

# Objects are created from a Class in instantiation

# Create an object from a built in Ruby class
name = String.new
name << 'Jane'
p name
p name.class

# Create an object that is an instance of a custom class
# Use the class method `new` which returns an object of the calling Class

class HumanBeing
end

jane = HumanBeing.new
p jane.class
