class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# The Pizza class contains the instance variable @name, which is signified
# by adding @ to the front of it. The variable name in Fruit is only a 
# local variable

# We can also call the instance_variables method on an object, which will
# return an array of any instance variables the object has

new_york = Pizza.new('pepperoni')
hawaii = Fruit.new('pineapple')

p new_york.instance_variables   # => [:@name]
p hawaii.instance_variables     # => [] (no instance variables)
