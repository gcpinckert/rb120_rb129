=begin
1. 
  - Create a class called MyCar. 
  - When you initialize a new instance or object of the class, allow the user to
  define some instance variables that tell us the year, color, and model of the
  car. 
  - Create an instance variable that is set to 0 during instantiation of the
  object to track the current speed of the car. 
  - Create instance methods that allow the car to speed up, brake, and shut the 
  car off.
2. 
  - Add an accessor method to your MyCar class to change and view the color.
  - Add an accessor method that views, but does not modify, the year
3.
  - Create a method `spray_paint` that is called by the object and can modify
  the color of the car
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
end

mikimoto = MyCar.new(2017, 'Grey', 'Subaru Impreza')

puts '---ex 1---'
puts mikimoto.speed_up(25)
puts mikimoto.speed_up(20)
puts mikimoto.brake(45)
puts mikimoto.turn_off
puts ''
puts '---ex 2---'
puts mikimoto.info
mikimoto.spray_paint("Black")
puts mikimoto.info
