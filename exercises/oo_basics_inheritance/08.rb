=begin
- Determine the lookup path used when invoked `cat1.color`
- Only list the classes and modules that Ruby will check
=end

class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new
cat1.color

# First Ruby will check the Cat class
# Next Ruby will check the Animal class
# Next Ruby will check the Object class
# Next Ruby will check the Kernel module
# Finally Ruby will check the BasicObject class
# Because Ruby never encounters a method called #color, it will throw an error
