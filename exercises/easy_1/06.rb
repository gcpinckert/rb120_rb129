=begin
Fix the given class to be resistant to future problems
=end

class Flight
  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end


=begin
We want to delete the setter and getter methods that are publicly available for
the @database_handle instance variable. This looks like an implementation detail, and
as such it's appropriate for us to make it private within the class.
=end