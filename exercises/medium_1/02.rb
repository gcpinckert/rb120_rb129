=begin
- A fixed length array is an array that always has a fixed number of elements
- Write a class that implements a fixed-length array
- It should support the given code
=end

class FixedArray
  def initialize(length)
    @length = length
    @elements = []
    set_up_elements
  end

  def [](idx)
    elements.fetch(idx)
  end

  def []=(idx, obj)
    self[idx]             # raise error - why does this work?
    elements[idx] = obj
  end

  def to_a
    elements.dup
  end

  def to_s
    strings = []
    elements.each do |obj|
      if obj == nil
        strings << 'nil'
      else
        strings << '"' + obj.to_s + '"'
      end
    end
    '[' + strings.join(', ') + ']'
  end

  private

  attr_reader :length, :elements

  def set_up_elements
    length.times { elements << nil }
  end
end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5
puts ""

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]
puts ""

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]
puts ""

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]
puts ""

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'
puts ""

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'
puts""

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end