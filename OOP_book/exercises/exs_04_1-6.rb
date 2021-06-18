=begin
1. 
  - Create a superclass Vehicle for MyCar class
  - Move behavior that isn't specific to the MyCar class to the superclass
  - Create a constant in MyCar that stores information about the vehicle
    that makes it different from other types of Vehicles
  - Create a new class called MyTruck that inherits from the superclass
  - Define a constant that separates it from MyCar in some way
2.
  - Add a class variable to the superclass to track number of objects
  - Create a method to print the value of this class variable as well
3. 
  - Create a module that you can mix in to one of the subclasses
  - It should describe a behavior unique to that subclass
4. 
  - Output all the method lookup chains for each class
5.
  - Move all the methods from MyCar that also pertain to MyTruck into Vehicle
  - Ensure that all the methods still work
6.
  - Make an `age` method that calls a private method to calculate the age
  - Make sure the private method is not available from outside the class
=end

module Haulable
  def move_furniture
    "Yeah, just throw all that in the back and we'll get going!"
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color, :speed
  attr_reader :year, :model

  def initialize(y, c, m)
    @year = y
    @model = m
    self.color = c
    self.speed = 0
    @@number_of_vehicles += 1
  end

  def spray_paint(color)
    self.color = color
  end

  def speed_up(mph)
    self.speed += mph
    puts "You are now traveling at #{speed} mph"
  end

  def brake(mph)
    self.speed -= mph
    puts "You are now traveling at #{speed} mph"
  end

  def turn_off
    self.speed = 0
    puts "The vehicle has been turned off. Don't forget your keys!"
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} mpg is the gas mileage."
  end

  def to_s
    "#{self.class} is a #{color} #{year} #{model}"
  end

  def self.how_many
    puts "There are #{@@number_of_vehicles} vehicles at the garage."
  end

  def display_age
    puts "This vehicle is #{calc_age} years old"
  end

  private

  def calc_age
    Time.new.year - self.year
  end
end

class MyCar < Vehicle
  FOLDING_TAILGATE = 'none'
end

class MyTruck < Vehicle
  include Haulable
  FOLDING_TAILGATE = 1
end

Vehicle.how_many  # -> 0

speed_whale = MyCar.new(1996, 'white', 'Buick Roadmaster')
puts speed_whale
# -> MyCar is a white 1996 Buick Roadmaster

pick_up = MyTruck.new(2014, 'grey', 'Toyota Tacoma')
puts pick_up
# -> MyTruck is a grey 2014 Toyota Tacoma

Vehicle.how_many  # -> 2

puts pick_up.move_furniture
  # -> Yeah, just throw all that in the back and we'll get going!

puts Vehicle.ancestors
  # -> Vehicle
  # -> Object
  # -> Kernel
  # -> BasicObject
puts MyCar.ancestors
  # -> MyCar
  # -> Vehicle
  # -> Object
  # -> Kernel
  # -> BasicObject
puts MyTruck.ancestors
  # -> MyTruck
  # -> Haulable
  # -> Vehicle
  # -> Object
  # -> Kernel
  # -> BasicObject

speed_whale.speed_up(60)
speed_whale.brake(30)
speed_whale.turn_off

pick_up.speed_up(60)
pick_up.brake(30)
pick_up.turn_off

speed_whale.display_age
  # -> This vehicle is 25 years old
speed_whale.calc_age
  # -> NoMethodError (private method)
