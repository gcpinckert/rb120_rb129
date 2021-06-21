=begin
- Complete the class such that the test cases work as intended
- Add any methods and instance variables required
- Do not make implementation details public
- Assume that input will always fit in the terminal window

# Test Cases:
banner = Banner.new('To boldly go where no one has gone before.')
puts banner
+--------------------------------------------+
|                                            |
| To boldly go where no one has gone before. |
|                                            |
+--------------------------------------------+

banner = Banner.new('')
puts banner
+--+
|  |
|  |
|  |
+--+

- We have three instance methods that make up the banner shape:
  #horizontal_rule, #empty_line, #message_line
  - Each should return a string representation of one 'line' of the Banner obj
- #horizontal_rule = '+' + ('-' * size of message + 2) + '+'
- #empty_line = '|' + (' ' * size of message + 2) + '|'
- #message_line = already defined
- We override to_s method with an array of 'lines' and calling join with a newline
  which will be output when we pass a Banner instance to `puts`

# Further exploration:
- Modify the class so that initializing a new object gives the option to
  specify a fixed banner width
  - Create an additional parameter banner_width in #initialize
  - Assign default value to 2 + message size (fits message in banner)
- When output, the message in the banner should be centered within the banner
  - Change each 'line' instance method to center message on given width
- How to handle cases where width is too narrow / message is too wide?
=end

class Banner
  def initialize(message)
    self.message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  attr_accessor :message

  def banner_width
    message.size + 2
  end

  def horizontal_rule
    "+#{'-' * banner_width}+"
  end

  def empty_line
    "|#{' ' * banner_width}|"
  end

  def message_line
    "|#{message.center(banner_width)}|"
  end
end

banner1 = Banner.new('To boldly go where no one has gone before.')
puts banner1
puts ''
banner2 = Banner.new('')
puts banner2
