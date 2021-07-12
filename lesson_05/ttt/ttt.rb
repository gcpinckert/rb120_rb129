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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def draw
    puts " (1)   (2)   (3)"
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts " (4)   (5)   (6)"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts " (7)   (8)   (9)"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
      puts "What's your name?"
      answer = gets.chomp.capitalize
      break unless answer.empty?
      puts "Please enter a name."
    end

    answer
  end

  def ask_human_marker
    answer = nil
    loop do
      puts "Choose a letter to be your marker. Must not be 'O'."
      answer = gets.chomp.upcase
      break if ('A'..'Z').include?(answer) && answer != 'O'
      puts "Please choose a letter A-Z. Must not be 'O'."
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
  COMPUTER_MARKER = "O"
  MAX_SCORE = 5

  attr_reader :board, :human, :computer

  def initialize
    clear
    @board = Board.new
    @human = Human.new
    @computer = Computer.new(COMPUTER_MARKER)
  end

  def play
    clear
    display_welcome_message
    set_up_game
    play_tournament
    display_goodbye_message
  end

  private

  def set_up_game
    set_first_player
  end

  def ask_first_player
    answer = nil
    loop do
      puts "Who should go first (h)uman, (c)omputer, or (r)andom?"
      answer = gets.chomp.downcase
      break if ['h', 'c', 'r'].include?(answer)
      puts "Please enter 'h', 'c', or 'r'"
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
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Hi #{human.name}!"
    puts ""
    puts "Welcome to Tic Tac Toe!"
    puts ""
    puts "The rules are simple, get three #{human.marker}'s in a row"
    puts "either vertically, horizontally, or diagonally."
    puts "But beware, #{computer.name} will be trying to do the same."
    puts "Block them wherever you can! Good luck!"
    puts ""
  end

  def display_winner
    if human.score > computer.score
      puts "#{human.name} has won the tournament!"
    else
      puts "#{computer.name} has won. I'm sorry, #{human.name}, you lost."
    end
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  # rubocop:disable Metrics/AbcSize
  def display_board
    puts ""
    puts "#{human.name} - #{human.marker} " \
      "#{computer.name} - #{computer.marker}"
    puts "#{human.name} - #{human.score} #{computer.name} - #{computer.score}"
    puts ""
    board.draw
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
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
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end

    puts "The score is now: #{human.name} - #{human.score}" \
      " #{computer.name} - #{computer.score}"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def tournament_winner?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = set_first_player
    clear
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def quit
    display_goodbye_message
    exit
  end
end

game = TTTGame.new
game.play
