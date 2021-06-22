class Transform
  attr_reader :text

  def initialize(string)
    @text = string
  end

  def uppercase
    text.upcase
  end

  def self.lowercase(string)
    string.downcase
  end
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
# => ABC
# => xyz
