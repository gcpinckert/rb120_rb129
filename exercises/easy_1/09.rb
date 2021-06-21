# Update the code to produce the following output:
# => My cat Pudding is 7 years old and has black and white fur.
# => My cat Butterscotch is 10 years old and has tan and white fur.

class Pet
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  attr_reader :fur

  def initialize(name, age, fur)
    super(name, age)
    @fur = fur
  end

  def to_s
    "My cat #{name} is #{age} years old and has #{fur} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch
