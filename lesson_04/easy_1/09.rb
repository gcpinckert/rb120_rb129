class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  # In method names, self refers to the class
  # It's use here marks cats_count as a Class method
  def self.cats_count
    @@cats_count
  end
end

# We do not need an instance to call a class method on
p Cat.cats_count            # => 0

mewmew = Cat.new('calico')
p Cat.cats_count            # => 1
# self from the method definition references Cat here
