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

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

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
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def reset_score
    self.score = 0
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  MAX_SCORE = 5

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def play
    clear
    display_welcome_message
    set_up_game
    loop do
      main_game
      display_winner
      break unless play_again?
      reset
      reset_scores
    end
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
    when 'h' then @current_marker = HUMAN_MARKER
    when 'c' then @current_marker = COMPUTER_MARKER
    when 'r' then @current_marker = [HUMAN_MARKER, COMPUTER_MARKER].sample
    end
  end

  def main_game
    loop do
      display_board
      player_move
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
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_winner
    if human.score > computer.score
      puts "You have won the tournament!"
    else
      puts "The computer has won. You lost the tournament."
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

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
      board[board.at_risk_square(COMPUTER_MARKER)] = COMPUTER_MARKER
    elsif !!board.at_risk_square(HUMAN_MARKER)
      board[board.at_risk_square(HUMAN_MARKER)] = COMPUTER_MARKER
    elsif board.squares[5].unmarked?
      board[5] = COMPUTER_MARKER
    else
      board[board.unmarked_keys.sample] = COMPUTER_MARKER
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      human.score += 1
      puts "You won!"
    when computer.marker
      computer.score += 1
      puts "Computer won!"
    else
      puts "It's a tie!"
    end

    puts "The score is now: You - #{human.score} Computer - #{computer.score}"
  end

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