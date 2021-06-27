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
    $stdout.write "#{CSI}0;1H"
    2.times { puts BORDER_LINE }
    (@@rows - 5).times do
      puts HORIZONTAL_LINE
    end
    2.times { puts BORDER_LINE }
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

  def beats?(other_move)
    beats.include?(other_move.value)
  end

  def self.return_subclass_instance(choice)
    Move::VALUES.each do |value|
      if choice == value
        return const_get(value.capitalize).new
      end
    end
    RobotSuperMove.new(choice)
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
    history = ["MOVE HISTORY", "", table_headings, ""]

    # results for each round
    (0...@@move_history[player1].size).each do |i|
      round_line = "(#{i + 1})".center(INSIDE_WIDTH / 3) +
                   @@move_history[player1][i].to_s.center(INSIDE_WIDTH / 3) +
                   @@move_history[player2][i].to_s.center(INSIDE_WIDTH / 3)
      history << round_line
    end

    history
  end
end

class RobotSuperMove < Move
  def initialize(value)
    @value = value
    @beats = VALUES
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

  def reset_score
    @score = 0
  end

  private

  def save_move
    Move.move_history[name] += [move.to_s]
  end
end

class Human < Player
  include Printable

  DEFEAT_CODES = ['ripley', 'sarah connor', 'towel', 'bone', 'r2d2']

  attr_accessor :defeat_code, :robot_opponent

  def initialize
    super
    @defeat_code = false
  end

  def set_name
    3.times { move_down_1 }
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

  def choose
    choice = nil
    loop do
      print_message_input ["Please make a choice: " \
                          "rock, paper, scissors, lizard, or spock:"]
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice) ||
               correct_defeat_found?(choice, robot_opponent)
      print_message ["Invalid choice."]
      move_down_1
    end

    robot_defeated! if correct_defeat_found?(choice, robot_opponent)
    self.move = Move.return_subclass_instance(choice)
    save_move
  end

  private

  def correct_defeat_found?(choice, robot_opponent)
    choice == robot_opponent.defeat_code
  end

  def robot_defeated!
    @defeat_code = true
  end
end

class Computer < Player
  attr_reader :move_percentages

  def initialize
    super
    @name = self.class.to_s
    @move_percentages = { 'rock' => 20, 'paper' => 20, 'scissors' => 20,
                          'lizard' => 20, 'spock' => 20 }
  end

  def choose
    self.move = Move.return_subclass_instance(weighted_choice)
    save_move
  end

  private

  def weighted_choice
    list_of_choices = []
    move_percentages.each do |move, percent|
      percent.times { list_of_choices << move }
    end

    list_of_choices.sample
  end
end

class Hal < Computer
  attr_reader :defeat_code, :super_move

  def initialize
    super
    @defeat_code = 'bone'
    @super_move = 'pod bay doors'
    @move_percentages = { 'rock' => 10, 'paper' => 15, 'scissors' => 30,
                          'lizard' => 15, 'spock' => 20, 'pod bay doors' => 10 }
  end
end

class Mother < Computer
  attr_reader :defeat_code, :super_move

  def initialize
    super
    @defeat_code = 'alien'
    @super_move = 'ripley'
    @move_percentages = { 'rock' => 20, 'paper' => 15, 'scissors' => 15,
                          'lizard' => 20, 'spock' => 20, 'alien' => 10 }
  end
end

class Skynet < Computer
  attr_reader :defeat_code, :super_move

  def initialize
    super
    @defeat_code = 'sarah connor'
    @super_move = 'terminator'
    @move_percentages = { 'rock' => 30, 'paper' => 20, 'scissors' => 15,
                          'lizard' => 10, 'spock' => 15, 'terminator' => 10 }
  end
end

class DeepThought < Computer
  attr_reader :defeat_code, :super_move

  def initialize
    super
    @defeat_code = 'towel'
    @super_move = '42'
    @move_percentages = { 'rock' => 16, 'paper' => 20, 'scissors' => 18,
                          'lizard' => 20, 'spock' => 16, '42' => 10 }
  end
end

class C3PO < Computer
  attr_reader :defeat_code, :super_move

  def initialize
    super
    @defeat_code = 'r2d2'
    @super_move = 'lightsaber'
    @move_percentages = { 'rock' => 15, 'paper' => 30, 'scissors' => 15,
                          'lizard' => 20, 'spock' => 10, 'lightsaber' => 10 }
  end
end

class RPSGame
  include Printable

  MAX_SCORE = 10
  OPPONENTS = [Hal.new, Mother.new, Skynet.new, DeepThought.new, C3PO.new]

  def initialize
    @human = Human.new
    @computer = OPPONENTS.sample
    human.robot_opponent = computer
  end

  def play
    loop do
      set_up_game
      loop do
        play_single_match
        break if human.defeat_code
        break if game_won? || !(play_again?)
        reset_round
      end
      human.defeat_code ? ultimate_win : show_move_history
      break unless play_again?
      reset_tournament
    end
    end_game
  end

  private

  attr_accessor :human, :computer

  def set_up_game
    print_border
    expand_window if window_too_small?
    print_banner(welcome_message)
    human.set_name
  end

  def expand_window
    print_banner(expand_window_message)
    loop do
      break if IO.console.winsize[0] >= 50
    end
    @@rows, @@columns = IO.console.winsize
    print_border
  end

  def play_single_match
    reset_round
    human.choose
    computer.choose
    update_scores!
    return if human.defeat_code
    show_winner
  end

  def reset_round
    print_border
    print_banner(welcome_message)
    3.times { move_down_1 }
  end

  def update_scores!
    human.score += 1 if human.move.beats?(computer.move)
    computer.score += 1 if computer.move.beats?(human.move)
  end

  def show_winner
    2.times { move_down_1 }
    print_message(moves_message)
    move_down_1
    print_message(winner_message)
    2.times { move_down_1 }
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

  def show_move_history
    print_border
    print_banner(Move.history + final_winner_message)
    2.times { move_down_1 }
  end

  def ultimate_win
    print_border
    print_banner(Move.history + ultimate_win_message)
    2.times { move_down_1 }
  end

  def reset_tournament
    reset_round
    Move.reset_move_history
    human.reset_score
    computer.reset_score
    human.defeat_code = false
  end

  def end_game
    2.times { move_down_1 }
    print_message(goodbye_message)
    move_to_bottom
    sleep(2)
    clear_screen
  end

  # game messages follow
  def welcome_message
    ["Welcome to Rock, Paper, Scissors, Lizard, Spock!", "",
     "Scissors cuts Paper covers Rock crushes",
     "Lizard poisons Spock smashes Scissors",
     "decapitates Lizard eats Paper disproves",
     "Spock vaporizes Rock crushes Scissors", "",
     "All your robot opponents have a super move that beats everything",
     "but there is a secret code you can enter to defeat them",
     "See if you can find them both - good luck!", "",
     "The first player to win #{MAX_SCORE} games wins!"]
  end

  def expand_window_message
    ["Please expand your terminal window for optimal " \
     "experience"]
  end

  def moves_message
    ["#{human.name} chose #{human.move}",
     "#{computer.name} chose #{computer.move}"]
  end

  def winner_message
    message = ["", "The current score:", "#{human.name} - #{human.score}",
               "#{computer.name} - #{computer.score}"]
    message.prepend(winner_result)
    message
  end

  def winner_result
    if human.move.beats?(computer.move)
      "#{human.name} won!"
    elsif computer.move.beats?(human.move)
      "#{computer.name} won!"
    else
      "It's a tie!"
    end
  end

  def final_winner_message
    message = ["", "FINAL SCORE", "", "#{human.name} - #{human.score}",
               "#{computer.name} - #{computer.score}", ""]
    message << final_winner_result
    message
  end

  def final_winner_result
    if human.score > computer.score
      "~*~  #{human.name} is the ultimate champion!!  ~*~"
    elsif computer.score > human.score
      "~*~  #{computer.name} is the ultimate champion!!  ~*~"
    else
      "~*~  It's a tie!  ~*~"
    end
  end

  def ultimate_win_message
    ["", "~*~  CONGRATULATIONS!! ~*~", "",
     "You have found the ultimate defeat code", "",
     "#{computer.name} has been vanquished and humanity is saved!",
     "#{human.name} is the ultimate winner!!"]
  end

  def goodbye_message
    ["Thanks for playing! Goodbye!"]
  end
end

RPSGame.new.play
