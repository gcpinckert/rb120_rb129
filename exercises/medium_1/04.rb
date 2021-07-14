=begin
# Theory
- A circular que is a collection of objects stored in a buffer
- The buffer is treated as connected end-to-end (as in a circle)
- When an object is added to the circular queue, it takes the position that
  immediately follows the most recently added object
- Removing an object removes the object that has been in the queue the longest
- This only works when there are empty spots in the buffer
- If the buffer is full, you have to get rid of an object to add an object
- Here, the object that has been in the queue the longest is replaced by the
  most recently added object

# Example (circular queue with room for 3 objects)
[[_], [_], [_]]   => all positions are initially empty
[[1], [_], [_]]   => add 1
[[1], [2], [_]]   => add 2
[[_], [2], [_]]   => remove oldest item (1)
[[_], [2], [3]]   => add 3
[[4], [2], [3]]   => add 4, queue is full
[[4], [_], [3]]   => remove oldest item (2)
[[4], [5], [3]]   => add 5, queue is full
[[4], [5], [6]]   => add 6, replaces oldest element (3)
[[7], [5], [6]]   => add 7, replaces oldest element (4)
[[7], [_], [6]]   => remove oldest item (5)
[[7], [_], [_]]   => remove oldest item (6)
[[_], [_], [_]]   => remove oldest item (7)
[[_], [_], [_]]   => remove nonexistent item (nil)

# Problem
- Write a CircularQueue class that implements a circular queue for arbitrary objects
- Obtain the buffer size via argument during initialization
- Provide the following methods:
  - enqueue to add an object
  - dequeue to remove (and return) the oldest object
    - return nil if queue is empty
- Assume none of the values stored are nil, nil designates an empty spot only

# Algorithm
- queue objects should have an attribute 'size' designated with an argument with new
- the items in the queue can be represented with an attribute array
- the array must never be larger than the given size attribute
- Initially the array contains the size number of nil objects
- To add a new item onto the array
  - pop off the last array item
  - unshift to add the new item to the beginning of the array
- To remove and return the oldest item in the array
  - If array is empty (i.e. all objects are nil), return nil
  - iterate backwards through the array
  - remove and return the first item you get to that is not a nil object
=end

class CircularQueue
  attr_reader :size, :array

  def initialize(size)
    @size = size
    @array = []
    size.times { @array << nil }
  end

  def enqueue(obj)
    array.pop
    array.unshift(obj)
  end

  def dequeue
    return nil if array.all? { |obj| obj == nil }
    oldest = nil
    (size - 1).downto(0) do |idx|
      obj = array[idx]
      if obj != nil
        oldest = obj
        array.delete(obj)
        array.insert(idx, nil)
        break
      end
    end

    oldest
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil