=begin
1. Add a class method to MyCar that calculates the gas mileage of any car
2. Override the to_s method to create a user friendly printout of an instance
=end

class MyCar
  attr_accessor :color, :model, :speed
  attr_reader :year

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def info
    "Your car is a #{color} #{year} #{model}"
  end

  def spray_paint(color)
    self.color = color
  end

  def speed_up(mph)
    self.speed += mph
    "You are now traveling at #{speed} mph"
  end

  def brake(mph)
    self.speed -= mph
    "You are now traveling at #{speed} mph"
  end

  def turn_off
    self.speed = 0
    "The car has been turned off. Don't forget your keys!"
  end

  # use a class method because no matter what car you have, gas mileage is
  # calculated the same way
  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} mpg is the gas mileage."
  end

  def to_s
    "This car is a #{color} #{model} from #{year}."
  end
end

blackened_death = MyCar.new(2016, "Black", "Ford Focus RS")

MyCar.gas_mileage(1, 14)

puts blackened_death
puts "#{blackened_death}"
