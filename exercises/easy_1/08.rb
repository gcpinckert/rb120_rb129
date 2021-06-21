# Write a class called Square that inherits from rectangle
# We should be able to access and output the area of a Square object
# Initialization of a Square takes 1 argument instead of 2

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

class Square < Rectangle
  def initialize(side)
    super(side, side)
  end
end

square = Square.new(5)
puts "area of square = #{square.area}"
