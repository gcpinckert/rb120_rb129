class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

# Based on the way initialize is defined, we need to pass 2 arguments to
# initialize a new instance of the Bag class

birkin = Bag.new('black', 'leather')
