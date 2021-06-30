class Cube
  # add accessor methods in order to access instance variables
  # creates both a getter and a setter method for @volume
  attr_accessor :volume

  def initialize(volume)
    @volume = volume
  end
end

# You can also access instance variables directly with instance_variable_get

cube = Cube.new(200)

p cube.instance_variable_get("@volume")   # => 200
p cube.volume                             # => 200
