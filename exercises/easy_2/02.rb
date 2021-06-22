# Correct the program
# Assume the Car class has complete implementation
# Ensure that cars have access to #drive

module Drivable
  # remove `self` to change drive from class to instance method
  def drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive
