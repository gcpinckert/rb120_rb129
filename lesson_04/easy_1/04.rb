class AngryCat
  def hiss
    puts "Hissssss!!!"
  end
end

# Create an instance of the AngryCat class with the Class::new method

spits = AngryCat.new
spits.hiss      # => Hissssss!!!
