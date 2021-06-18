=begin
- Add an instance method named #rename that renames the object when called
=end

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def rename(name)
    self.name = name
  end
end

kitty = Cat.new('Sophie')
puts kitty.name
  # Sophie
kitty.rename('Chloe')
puts kitty.name
  # Chloe
