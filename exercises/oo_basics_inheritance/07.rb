=begin
- Determine the lookup path used when invoking `cat1.color`
- Only list the classes checked by Ruby when searching for #color
=end

class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color

puts Cat.ancestors

# First Ruby checks the Cat class for any methods called #color
# Next Ruby checks the Animal class for any methods called #color
# We have defined our getter #color method on line 7 in the Animal class
# So Ruby invokes this method which returns the value referenced by @color
