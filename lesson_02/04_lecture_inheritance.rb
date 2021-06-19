=begin
1. Keep track of different breeds of dogs
  - Create a sub-class from Dog called Bulldog
  - Override the swim method in the Bulldog subclass
2. Create a new class called Cat
  - Cat objects should have the same behaviors except for swim and fetch
  - Don't repeat methods, come up with a class hierarchy instead
4. What is the method lookup path and how is it important?
  - Ruby moves outward from the innermost class to the highest superclass
    when searching for a method. If our calling object is a Pet than this would
    be: Pet > Object > Kernel. In the case of Bulldog it would be Bulldog > Dog
    > Pet > Object > Kernel. 
  - How Ruby looks up methods matters because it stops looking when it finds a
    method that has the name of the one it is searching for. Lower level methods,
    therefore, can override higher level ones causing different behaviors
    depending on the structure of the lookup path.
=end

class Pet
  def speak(sound)
    sound
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  DOGS_SAY = 'bark!'

  def speak
    super(DOGS_SAY)
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  CATS_SAY = 'meow!'

  def speak
    super(CATS_SAY)
  end
end

class Bulldog < Dog
  # overrides `swim` method in parent class
  def swim
    "can't swim!"
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim            # => "swimming!"

snuffles = Bulldog.new
puts snuffles.speak        # => "bark!" (Bulldog inherits speak method)
puts snuffles.swim         # => "can't swim!"

paws = Cat.new
puts paws.speak             # => 'meow!'

pete = Pet.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

pete.run                # => "running!"
#pete.speak              # => ArgumentError

kitty.run               # => "running!"
kitty.speak             # => "meow!"
#kitty.fetch             # => NoMethodError

dave.speak              # => "bark!"

bud.run                 # => "running!"
bud.swim                # => "can't swim!"


