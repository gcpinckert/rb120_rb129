=begin
- make the program automatically invoke #start_engine upon creation of a new
  Truck object
=end

class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle
  def initialize(year)
    super
    start_engine
  end

  def start_engine
    puts 'Ready to go!'
  end
end

truck1 = Truck.new(1994)    # -> 'Ready to go!'
puts truck1.year            # -> 1994
