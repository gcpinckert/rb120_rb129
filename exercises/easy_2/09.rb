# Write one method so the program generates the expected output
# Create superclass for more generic methods
# Have generic 'walk' method call on subclass specific 'gait' method
# Option 2: create Walkable module with 'walk' method to include
# Module may be more appropriate because this is a has-a relationship
# i.e. it adds additional functionality to the classes

class Mammal
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def walk
    puts "#{self.name} #{gait} forward"
  end
end

class Person < Mammal
  private

  def gait
    "strolls"
  end
end

class Cat < Mammal
  private

  def gait
    "saunters"
  end
end

class Cheetah < Mammal
  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"
