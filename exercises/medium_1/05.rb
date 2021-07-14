=begin
Write a class that implements a miniature stack-and-register based programming
language that has the following commands:
  - `n` => Place value `n` in the register. Do not modify the stack
  - `PUSH` => Push the register value onto the stack. Leave the value in the
    register
  - `ADD` => Pops a value from the stack and adds it to the register, storing
    the result in the register
  - `SUB` => Pops a value from the stack and subtracts if from the register,
    storing the result in the register
  - `MULT` => Pops a value from the stack and multiplies it by the register,
    storing the result in the register
  - `DIV` => Pops a value from the stack and divides it into the register,
    storing the integer result in the register
  - `MOD` => Pops a value from the stack and divides it into the register,
    storing the integer remainder of the division in the register
  - `POP` => Removed the topmost item from the stack and places it in the
    register
  - `PRINT` => Print the register value
- All operations are integer operations
- Programs are supplied via a string passed in as an argument.
- Produce an error if an unexpected item is present in the string
- Produce an error if a required stack value is not on the stack (i.e stack is empty)
- In all error cases, no further processing should be performed
- Initialize the register to 0
=end

class CommandError < StandardError 
  def initialize(msg="Invalid Token")
    super
  end
end

class EmptyStackError < StandardError
  def initialize(msg="Empty stack!")
    super
  end
end

class Minilang
  attr_reader :commands, :stack
  attr_accessor :register

  def initialize(program)
    @commands = program.split
    @register = 0
    @stack = []
  end

  def eval
    commands.each { |command| eval_single_command(command) }
  rescue StandardError => e
    puts e.message
  end

  def eval_single_command(command)
      case command
      when /\A[-+]?\d+\z/ then self.register = command.to_i
      when 'PUSH'         then self.push
      when 'ADD'          then self.add
      when 'SUB'          then self.subtract
      when 'MULT'         then self.multiply
      when 'DIV'          then self.divide
      when 'MOD'          then self.modulo
      when 'POP'          then self.pop
      when 'PRINT'        then self.output
      else                raise CommandError("Invalid Token: #{command}")
      end
  end

  def push
    stack << self.register
  end

  def add
    raise EmptyStackError if stack.empty?
    self.register += stack.pop
  end

  def subtract
    raise EmptyStackError if stack.empty?
    self.register -= stack.pop
  end

  def multiply
    raise EmptyStackError if stack.empty?
    self.register *= stack.pop
  end

  def divide
    raise EmptyStackError if stack.empty?
    self.register /= stack.pop
  end

  def modulo
    raise EmptyStackError if stack.empty?
    self.register %= stack.pop
  end

  def pop
    raise EmptyStackError if stack.empty?
    self.register = stack.pop
  end

  def output
    puts self.register
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)