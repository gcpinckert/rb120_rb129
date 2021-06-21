=begin
Expected Output:
The author of "Snow Crash" is Neil Stephenson.
book = "Snow Crash", by Neil Stephenson.
=end

class Book
  attr_accessor :author, :title

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

=begin
Setting up the state of an object (as represented by instance variables) from
outside the class in separate steps as in the case above is not ideal. This is
because _all_ books have authors and titles, so it doesn't make sense to assign
these attributes separately in each instance from outside the class. Better
to lump it into a singly initialization step so that the behavior is the same
for all instances of the class Book.
=end
