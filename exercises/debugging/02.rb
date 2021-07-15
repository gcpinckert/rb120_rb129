class Animal
  def initialize(diet, superpower)
    @diet = diet
    @superpower = superpower
  end

  def move
    puts "I'm moving!"
  end

  def superpower
    puts "I can #{@superpower}!"
  end
end

class Fish < Animal
  def move
    puts "I'm swimming!"
  end
end

class Bird < Animal
end

class FlightlessBird < Bird
  def initialize(diet, superpower)
    super
  end

  def move
    puts "I'm running!"
  end
end

class SongBird < Bird
  def initialize(diet, superpower, song)
    super(diet, superpower)
    @song = song
  end

  def move
    puts "I'm flying!"
  end
end

# Examples

unicornfish = Fish.new(:herbivore, 'breathe underwater')
penguin = FlightlessBird.new(:carnivore, 'drink sea water')
robin = SongBird.new(:omnivore, 'sing', 'chirp chirrr chirp chirp chirrrr')

=begin
The problem comes from line 37 of the code (super). Calling the super method without
appending () or any specific arguments causes all the arguments passed to initialize
to be passed to the higher level initialize method by default. In this case, the
higher level initialize method is defined in the Animal Superclass. This method
expects only two arguments. By calling super alone, we are passing it three. Instead,
we must specify which arguments get passed to the superclass's method. In this case,
we can see these are diet and superpower. Song will be assigned to the instance
variable @song in the subclass SongBird.

# Further Exploration

We do not need to define the initialize method in the FlightlessBird subclass. This
is because it only calls super, therefore acting exactly the same as the method
inherited from the superclass Animal. We can therefore completely eliminate it and
rely solely on the inherited behavior.
=end