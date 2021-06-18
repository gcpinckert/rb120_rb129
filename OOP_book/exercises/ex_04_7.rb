=begin
7. 
  - Create a class called Student with attributes name and grade
  - Do not make the grade getter public
  - Create a better_grade_than? method
=end

class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    self.name = name
    self.grade = grade
  end

  def better_grade_then?(other_student)
    grade > other_student.grade
  end

  def display_grade
    puts grade
  end

  protected

  attr_reader :grade
end

joe = Student.new('Joe', 95)
bob = Student.new('Bob', 87)

puts "Well done!" if joe.better_grade_then?(bob)
  # -> Well done!