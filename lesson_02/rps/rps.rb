require 'pry'

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  @@move_history = Hash.new([])

  attr_reader :beats, :value

  def initialize(value)
    @value = value
    @beats = []
  end

  def to_s
    @value
  end

  def self.move_history
    @@move_history
  end

  def self.display_history
    player1, player2 = @@move_history.keys

    puts "MOVE HISTORY".center(60, '-')
    puts "Round".ljust(10) + player1.center(25) + player2.center(25)

    (0...@@move_history[player1].size).each do |i|
      puts "(#{i + 1})".ljust(10) + "#{@@move_history[player1][i]}".center(25) +
           "#{@@move_history[player2][i]}".center(25)
    end
  end

  def beats?(other_move)
    beats.include?(other_move.value)
  end

  def tie?(other_move)
    @value == other_move.to_s
  end

  def self.return_subclass_instance(choice)
    Move::VALUES.each_with_index do |value, index|
      if choice == value
        return const_get(value.capitalize).new
      end
    end
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
    @beats = ['lizard', 'scissors']
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
    @beats = ['rock', 'spock']
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
    @beats = ['paper', 'lizard']
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
    @beats = ['spock', 'paper']
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
    @beats = ['rock', 'scissors']
  end
end

class Player
  attr_accessor :move, :score, :name

  def initialize
    set_name
    @move = nil
    @score = 0
  end

  def save_move
    Move.move_history[name] += [move.to_s]
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
    end

    self.name = n
  end

  def chose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "Invalid choice."
    end

    self.move = Move.return_subclass_instance(choice)
    save_move
  end
end

class Computer < Player
  def set_name
    self.name = ["Mother", "Skynet", "Deep Thought", "Hal", "C-3PO"].sample
  end

  def chose
    self.move = Move.return_subclass_instance(Move::VALUES.sample)
    save_move
  end
end

class RPSGame
  MAX_SCORE = 10

  attr_accessor :human, :computer

  def initialize
    clear_screen
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
  end

  def clear_screen
    system("clear") || system("cls")
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
    puts "The first player to win #{MAX_SCORE} games wins!"
  end

  def play_single_match
    human.chose
    clear_screen
    computer.chose
    update_scores!
    display_moves
    display_winner
  end

  def update_scores!
    human.score += 1 if human.move.beats?(computer.move)
    computer.score += 1 if computer.move.beats?(human.move)
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    puts "#{human.name} won!" if human.move.beats?(computer.move)
    puts "#{computer.name} won!" if computer.move.beats?(human.move)
    puts "It's a tie!" if human.move.tie?(computer.move)
    puts "The score is now: #{human.name} - #{human.score} " \
         "#{computer.name} - #{computer.score}"
  end

  def game_won?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Invalid choice, please enter 'y' or 'n'"
    end

    answer == 'y'
  end

  def display_goodbye_message
    puts "Thanks for playing! Goodbye!"
  end

  def play
    loop do
      loop do
        play_single_match
        break if game_won?
      end
      Move.display_history
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play