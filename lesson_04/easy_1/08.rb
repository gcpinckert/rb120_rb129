class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    # Within instance methods self refers to the object that calls the method
    self.age += 1
  end
end

mewmew = Cat.new('calico')
p mewmew.age                # => 0
mewmew.make_one_year_older  # self within the method references mewmew
p mewmew.age                # => 1
