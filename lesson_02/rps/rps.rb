require 'io/console'

module Printable
  CSI = "\e["
  @@rows, @@columns = IO.console.winsize
  BORDER_LINE = "*" * @@columns
  INSIDE_WIDTH = @@columns - 4
  HORIZONTAL_LINE = "**#{' ' * INSIDE_WIDTH}**"

  def window_too_small?
    @@rows < 50
  end
  
  def clear_screen
    system("clear") || system("cls")
  end

  def print_border
    $stdout.write "#{CSI}2;1H"
    2.times {puts BORDER_LINE}
    (@@rows - 5).times do
      puts HORIZONTAL_LINE
    end
    2.times{puts BORDER_LINE}
  end

  def print_banner(message)
    $stdout.write "#{CSI}4;1H"
    message.each do |line|
      puts "**#{line.center(INSIDE_WIDTH)}**"
    end
  end

  def print_message(message)
    message.each do |line|
      left_margin
      puts "#{line.ljust(@@columns - 8)}**"
    end
  end

  def print_message_input(message)
    print_message(message)
    left_margin
  end

  def move_down_1
    $stdout.write "#{CSI}1B"
  end

  def move_up_1
    $stdout.write "#{CSI}1A"
  end

  def clear_1_above
    move_up_1
    puts HORIZONTAL_LINE
    move_up_1
  end

  def left_margin
    $stdout.write "#{CSI}6C"
  end

  def move_to_bottom
    $stdout.write "#{CSI}#{@@rows};1H"
  end
end

class Move
  include Printable

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

  def self.reset_move_history
    @@move_history = Hash.new([])
  end

  def self.history
    player1, player2 = @@move_history.keys
    table_headings = "Round".center(INSIDE_WIDTH / 3) +
                     player1.center(INSIDE_WIDTH / 3) +
                     player2.center(INSIDE_WIDTH / 3)

    # history display headings
    history = ["MOVE HISTORY", "",  table_headings, ""]

    # results for each round
    (0...@@move_history[player1].size).each do |i|
      round_line = "(#{i + 1})".center(INSIDE_WIDTH / 3) + 
                   "#{@@move_history[player1][i]}".center(INSIDE_WIDTH / 3) +
                   "#{@@move_history[player2][i]}".center(INSIDE_WIDTH / 3)
      history << round_line
    end

    history
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
    @name = ''
    @move = nil
    @score = 0
  end

  def save_move
    Move.move_history[name] += [move.to_s]
  end
end

class Human < Player
  include Printable

  def set_name
    3.times {move_down_1}
    n = ''
    loop do
      print_message_input ["What's your name?"]
      n = gets.chomp
      break unless n.empty?
      print_message ["Must enter a name."]
      move_down_1
    end

    self.name = n
  end

  def chose
    choice = nil
    loop do
      print_message_input ["Please make a choice: " \
                          "rock, paper, scissors, lizard, or spock:"]
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      print_message ["Invalid choice."]
      move_down_1
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
  include Printable

  MAX_SCORE = 10

  attr_accessor :human, :computer
  attr_reader :messages

  def initialize
    clear_screen
    @human = Human.new
    @computer = Computer.new
  end

  def expand_window
    print_banner(expand_window_message)
    loop do
      break if IO.console.winsize[0] >=50
    end
    clear_screen
    @@rows, @@columns = IO.console.winsize
    print_border
  end

  def welcome_message
    ["Welcome to Rock, Paper, Scissors, Lizard, Spock!", "",
      "Scissors cuts Paper covers Rock crushes",
      "Lizard poisons Spock smashes Scissors",
      "decapitates Lizard eats Paper disproves",
      "Spock vaporizes Rock crushes Scissors", "",
      "The first player to win #{RPSGame::MAX_SCORE} games wins!"]
  end

  def expand_window_message
    ["Please expand your terminal window for optimal " \
      "experience"]
  end

  def reset_round
    clear_screen
    print_border
    print_banner(welcome_message)
    3.times {move_down_1}
  end

  def play_single_match
    reset_round
    human.chose
    computer.chose
    update_scores!
    2.times {move_down_1}
    print_message(moves_message)
    move_down_1
    print_message(winner_message)
  end

  def update_scores!
    human.score += 1 if human.move.beats?(computer.move)
    computer.score += 1 if computer.move.beats?(human.move)
  end

  def moves_message
    ["#{human.name} chose #{human.move}",
    "#{computer.name} chose #{computer.move}"]
  end

  def winner_message
    message = ["", "The current score:", "#{human.name} - #{human.score}",
              "#{computer.name} - #{computer.score}"]

    if human.move.beats?(computer.move)
      message.prepend("#{human.name} won!")
    elsif computer.move.beats?(human.move)
      message.prepend("#{computer.name} won!")
    else
      message.prepend("It's a tie!")
    end

    message
  end

  def game_won?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def play_again?
    answer = nil

    loop do
      print_message_input ["Would you like to play again? (y/n)"]
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      print_message ["Invalid choice, please enter 'y' or 'n'"]
      move_down_1
    end

    answer == 'y'
  end

  def goodbye_message
    ["Thanks for playing! Goodbye!"]
  end

  def play
    print_border
    expand_window if window_too_small?
    print_banner(welcome_message)
    human.set_name
    computer.set_name
    loop do
      loop do
        play_single_match
        2.times {move_down_1}
        break if game_won? || !(play_again?)
        reset_round
      end
      clear_screen
      print_border
      print_banner(Move.history)
      2.times{move_down_1}
      break unless play_again?
      reset_round
      Move.reset_move_history
    end
    2.times{move_down_1}
    print_message(goodbye_message)
    move_to_bottom
    sleep(2)
    clear_screen
  end
end

RPSGame.new.play