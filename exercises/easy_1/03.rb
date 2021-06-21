=begin
- Complete the program so it produces the expected output:
= > The author of "Snow Crash" is Neil Stephenson.
= > book = "Snow Crash", by Neil Stephenson.
=end

class Book
  attr_reader :title, :author

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

=begin
Further Exploration
- attr_reader = a getter method, returns only the value referenced by the
  instance variable that is named as a symbol
- attr_writer = a setter method, allows us to assign or reassign the value
  referenced by the instance variable that is named as a symbol
- attr_accessor = generates both getter and setter methods
- here we only use attr_reader because the given code does nto require us
  to reassign the value referenced by @title or @name at any point, and we
  don't necessarily want to make that functionality available
- we could also add the getter methods by defining them manually. It takes
  up more space in the code, but does allow us to implement other functionality
  into the getter method, such as any necessary formatting. Here, though, this
  is not required so we stick with the more efficient attr_reader shorthand
=end
