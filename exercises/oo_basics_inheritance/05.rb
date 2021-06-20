=begin
- create a Towable module
- should contain a method #tow
- method prints 'I can tow a trailer!' when invoked
- include Towable in Truck Class
=end

module Towable
  def tow
    puts 'I can tow a trailer!'
  end
end

class Truck
  include Towable
end

class Car
end

truck1 = Truck.new
truck1.tow
