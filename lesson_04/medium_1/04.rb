class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

hi = Hello.new
hi.hi             # => "Hello"

bye = Goodbye.new
bye.bye           # => "Goodbye"