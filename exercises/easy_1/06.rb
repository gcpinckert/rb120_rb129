=begin
Fix the given class to be resistant to future problems
=end

class Flight
  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end
