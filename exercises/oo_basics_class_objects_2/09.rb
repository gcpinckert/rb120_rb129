=begin
- Add a method called share_secret
- Should print the value of @secret when invoked
=end

class Person
  attr_writer :secret

  def share_secret
    puts secret
  end

  private

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret
  # -> Shh.. this is a secret!
