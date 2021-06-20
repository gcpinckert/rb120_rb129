=begin
- allow Truck to accept a second argument upon initialization
- name the parameter `bed_type`
- ensure that Car accepts only one argument upon initialization
=end

class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle
  attr_accessor :bed_type

  def initialize(year, bed_type)
    super(year)
    self.bed_type = bed_type
  end
end

class Car < Vehicle
end

truck1 = Truck.new(1994, 'Short')
puts truck1.year
puts truck1.bed_type