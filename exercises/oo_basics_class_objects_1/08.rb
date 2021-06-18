=begin
- Add a setter method named #name=
- Rename kitty to 'Luna'
- Invoke #greet again
=end

class Cat
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
  # -> Hello! My name is Sophie!
kitty.name('Luna')
kitty.greet
  # -> Hello! My name is Luna!
