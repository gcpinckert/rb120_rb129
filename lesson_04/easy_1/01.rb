p true.class                        # => TrueClass
p 'hello'.class                     # => String
p [1, 2, 3, 'happy days'].class     # => Array
p 142.class                         # => Integer

=begin
`true`, `'hello'`, `[1, 2, 3, 'happy days']`, and `142` are all objects. Just
about everything in Ruby is an object. We can figure out the class an object
belongs to by calling the Object#class method on it.
=end