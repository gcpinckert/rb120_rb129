=begin
- 3 classes: Student, Graduate, and Undergraduate
- Fill in missing implementation details for #initialize methods such that:
  - Graduate students have the option to use on-campus parking
  - Undergraduates do not have the option to use on-campus parking
- Both Graduate and Undergraduate students have a name and year
- Do not add/alter more than 5 lines of code

STRATEGY
- make both Graduate and Undergraduate students inherit from Student
- call the super initialize method to assign name and year attributes
- Assign on-campus to the parking attribute for Graduate students
- Do not assign any additional parking for undergraduate students

=end

class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student
  def initialize(name, year)
    super
  end
end