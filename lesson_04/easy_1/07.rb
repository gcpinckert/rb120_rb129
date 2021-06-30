# The default return of to_s on an object is a string representation of that
# object. This consists of the object's class and encoding id. The method
# is described in the Ruby docs for Object instance methods.

class Cat; end

mewmew = Cat.new
puts mewmew   # => #<Cat:0x000056310357bba8>
