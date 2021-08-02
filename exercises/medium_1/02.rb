=begin
# Problem:
- Fixed Length Array = an array that always has a fixed number of elements
- Write a class that implements a fixed length array
- Needs the following behaviors:
  - Initialize with one argument, an integer representing the length of the array
  - Array should be initialized with all elements set to nil
  - Be able to reference individual elements in the array with FixedArray#[] method
    - Accepts integer as argument, representing index of element to return
    - Should also accept negative integer as argument, representing negative index
  - Define a FixedArray#to_a method that returns an array of all elements within FixedArray
  - Define a FixedArray#[]=() setter method that allows reassignment of individual elements within the array
  - Define a FixedArray#to_s method that returns a string representation of the array
    - Use double quotes to show string values
=end

class FixedArray
  def initialize(length)
    @elements = [nil] * length
  end
  
  def [](index)
    # raises IndexError if index is out of range
    elements.fetch(index)
  end
  
  def []=(index, value)
    # relies on above implementation to raise error if out of range
    self[index]
    elements[index] = value
  end
  
  def to_a
    elements
  end
  
  def to_s
    "[#{elements.map(&:inspect).join(', ')}]"
  end
  
  private
  
  attr_reader :elements
end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

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
