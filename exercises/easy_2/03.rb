# Modify the House class so the program will work
# Only define a single new method in House

class House
  # Comparable helps us compare objects who exhibit some kind of order
  include Comparable

  attr_reader :price

  def initialize(price)
    # @price represents a state that is an orderable integer
    @price = price
  end

  # Use <=> to implement all regular comparison operators
  def <=>(other_house)
    # compare price states of two House instances
    price <=> other_house.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1
# => Home 1 is cheaper
# => Home 2 is more expensive