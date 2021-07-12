require 'io/console'

module Printable
  CSI = "\e["
  ROWS, COLUMNS = IO.console.winsize
  BORDER_LINE = '#' * COLUMNS
  INSIDE_WIDTH = COLUMNS - 4
  LEFT_MARGIN = (INSIDE_WIDTH / 3)
  HORIZONTAL_LINE = "###{' ' * INSIDE_WIDTH}##"

  def clear
    system("clear") || system("cls")
  end

  def clear_with_border
    clear
    print_border
  end

  def print_border
    $stdout.write "#{CSI}0;1H"
    2.times { puts BORDER_LINE }
    (ROWS - 5).times { puts HORIZONTAL_LINE }
    2.times { puts BORDER_LINE }
  end

  def print_banner(message)
    $stdout.write "#{CSI}4;1H"
    message.each do |line|
      puts "###{line.center(INSIDE_WIDTH)}##"
    end
  end

  def print_message(message)
    message.each do |line|
      puts "###{line.center(INSIDE_WIDTH)}##"
    end
  end

  def print_message_input(message)
    print_message(message)
    set_to_left_margin
  end

  def set_to_left_margin
    $stdout.write "#{CSI}#{LEFT_MARGIN}C"
  end

  def set_to_top
    $stdout.write "#{CSI}4;1H"
  end

  def set_to_bottom
    $stdout.write "#{CSI}#{ROWS};1H"
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def center_square_open?
    @squares[5].unmarked?
  end

  def at_risk_square(marker)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if complete_this_line?(squares, marker)
        return key_of_unmarked_square_from_line(line)
      end
    end

    nil
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/MethodLength
  def lines
    [" (1)   (2)   (3) ",
     "     |     |     ",
     "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  ",
     "     |     |     ",
     "-----+-----+-----",
     " (4)   (5)   (6) ",
     "     |     |     ",
     "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}  ",
     "     |     |     ",
     "-----+-----+-----",
     " (7)   (8)   (9) ",
     "     |     |     ",
     "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  ",
     "     |     |     "]
  end
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def complete_this_line?(squares, marker)
    markers = squares.collect(&:marker)
    markers.count(marker) == 2 &&
      markers.count(Square::INITIAL_MARKER) == 1
  end

  def key_of_unmarked_square_from_line(line)
    @squares.select do |sq_num, square|
      line.include?(sq_num) && square.unmarked?
    end.keys.first
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def reset_score
    self.score = 0
  end
end

class Human < Player
  include Printable

  attr_reader :name

  def initialize
    @name = ask_human_name
    @marker = ask_human_marker
    @score = 0
  end

  private

  def ask_human_name
    answer = nil
    loop do
      set_to_top
      print_message_input ["What's your name?"]
      answer = gets.chomp.capitalize
      break unless answer.empty?
      print_message ["Please enter a name."]
    end

    answer
  end

  def ask_human_marker
    answer = nil
    loop do
      print_message_input ["Choose a letter to be your marker. Cannot be 'O'."]
      answer = gets.chomp.upcase
      break if ('A'..'Z').include?(answer) && answer != 'O'
      print_message ["Please choose a letter A-Z. Must not be 'O'."]
    end

    answer
  end
end

class Computer < Player
  COMPUTER_NAMES = ['Deep Thought', 'Hal', 'Skynet', 'C3PO', 'R2D2', 'Robbie']

  attr_reader :name

  def initialize(marker)
    super
    @name = COMPUTER_NAMES.sample
  end
end

class TTTGame
  include Printable

  COMPUTER_MARKER = "O"
  MAX_SCORE = 5

  attr_reader :board, :human, :computer

  def initialize
    clear_with_border
    @board = Board.new
    @human = Human.new
    @computer = Computer.new(COMPUTER_MARKER)
  end

  def play
    clear_with_border
    display_welcome_message
    set_first_player
    play_tournament
    display_goodbye_message
  end

  private

  def ask_first_player
    answer = nil
    loop do
      print_message_input ["Who should go first human, computer, or random?",
                           "Enter 'h', 'c', or 'r'."]
      answer = gets.chomp.downcase
      break if ['h', 'c', 'r'].include?(answer)
      print_message ["Please enter 'h', 'c', or 'r'"]
    end

    answer
  end

  def set_first_player
    case ask_first_player
    when 'h' then @current_marker = human.marker
    when 'c' then @current_marker = COMPUTER_MARKER
    when 'r' then @current_marker = [human.marker, COMPUTER_MARKER].sample
    end
  end

  def play_tournament
    loop do
      main_game
      display_winner
      break unless play_again?
      reset
      reset_scores
    end
  end

  def main_game
    loop do
      display_board
      player_move
      update_score
      display_result
      break if tournament_winner?
      quit unless play_again?
      reset
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_with_border_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    welcome_message = ["Hi #{human.name}!", "", "Welcome to Tic Tac Toe!", "",
                       "Your goal: get three #{human.marker}'s in a row",
                       "either vertically, horizontally, or diagonally.",
                       "Beware, #{computer.name} is trying to do the same.",
                       "Block them wherever you can! Good luck!", ""]
    print_banner(welcome_message)
  end

  def display_winner
    if human.score > computer.score
      puts "#{human.name} has won the tournament!"
    else
      puts "#{computer.name} has won. I'm sorry, #{human.name}, you lost."
    end
  end

  def display_goodbye_message
    print_banner ["", "Thanks for playing Tic Tac Toe! Goodbye!"]
  end

  def clear_with_border_screen_and_display_board
    clear_with_border
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  # rubocop:disable Metrics/AbcSize
  def display_board
    headings = ["", "Markers: #{human.name} - #{human.marker}" \
                " #{computer.name} - #{computer.marker}",
                "Score: #{human.name} - #{human.score} " \
                "#{computer.name} - #{computer.score}", ""]
    print_banner(headings + board.lines + [""])
  end
  # rubocop:enable Metrics/AbcSize

  def human_moves
    print_message_input ["Choose a square (#{joinor(board.unmarked_keys)}): "]
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      print_message ["Sorry, that's not a valid choice."]
    end

    board[square] = human.marker
  end

  def joinor(squares)
    if squares.size < 3
      squares.join(' or ')
    else
      squares[0..-2].join(', ') + ' or ' + squares[-1].to_s
    end
  end

  def computer_moves
    if !!board.at_risk_square(COMPUTER_MARKER)
      offensive_move
    elsif !!board.at_risk_square(human.marker)
      defensive_move
    elsif board.center_square_open?
      select_center_square
    else
      select_random_square
    end
  end

  def offensive_move
    board[board.at_risk_square(COMPUTER_MARKER)] = COMPUTER_MARKER
  end

  def defensive_move
    board[board.at_risk_square(human.marker)] = COMPUTER_MARKER
  end

  def select_center_square
    board[5] = COMPUTER_MARKER
  end

  def select_random_square
    board[board.unmarked_keys.sample] = COMPUTER_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def update_score
    case board.winning_marker
    when human.marker then human.score += 1
    when computer.marker then computer.score += 1
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def display_result
    clear_with_border_screen_and_display_board

    case board.winning_marker
    when human.marker
      print_message ["#{human.name} won!"]
    when computer.marker
      print_message ["#{computer.name} won!"]
    else
      print_message ["It's a tie!"]
    end

    print_message ["", "The score is now: #{human.name} - #{human.score}" \
      " #{computer.name} - #{computer.score}", ""]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def tournament_winner?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def play_again?
    answer = nil
    loop do
      print_message_input ["Would you like to play again? (y/n)"]
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      print_message ["Sorry, must be y or n"]
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = set_first_player
    clear_with_border
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def quit
    clear_with_border
    display_goodbye_message
    set_to_bottom
    sleep(2)
    clear
    exit
  end
end

game = TTTGame.new
game.play
