class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new
puts Something.dupdata
  # => 'ByeBye'
  # Because the class method ::dupdata is called which returns 'ByeBye'
puts thing.dupdata
  # => 'HelloHello'
  # Because the instance method #dupdata is called on the thing object
  # which returns the value of the instance variable @data (assigned upon
  # initialization) concatenated to itself

# Class methods and instance methods are entirely separate
