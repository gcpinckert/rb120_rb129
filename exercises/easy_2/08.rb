 # Fix the code

 class Expander
  def initialize(string)
    @string = string
  end

  def to_s
    # don't call private methods with `self`
    expand(3)
  end

  private

  def expand(n)
    @string * n
  end
end

expander = Expander.new('xyz')
puts expander
