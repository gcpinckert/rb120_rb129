require 'io/console'

module Printable
  CSI = "\e["
  @@rows, @@columns = IO.console.winsize

  def clear
    system("clear") || system("cls")
  end

  def window_too_small?
    @@rows < 50 || @@columns < 120
  end

  def print_centered(message)
    puts message.center(@@columns)
  end

  def expand_window
    print_centered("Please expand the terminal window for optimal" \
         " experience")
    loop do
      @@rows, @@columns = IO.console.winsize
      break if @@rows >= 50 && @@columns >= 120
    end
    clear
  end

  def set_margin
    $stdout.write "#{CSI}#{@@columns / 2}C"
  end
end

class Deck
  SUITS = %w(H D C S)
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  attr_accessor :cards

  def initialize
    @cards = []
    SUITS.each do |s|
      VALUES.each do |v|
        @cards << Card.new(s, v)
      end
    end
  end

  def deal_single_card!
    @cards.shuffle!.pop
  end
end

class Card
  extend Printable

  HIDDEN_CARD = [" _________ ",
                 "|\\\\\\\\\\\\\\\\\\|",
                 "|/////////|",
                 "|\\\\\\\\\\\\\\\\\\|",
                 "|/////////|",
                 "|\\\\\\\\\\\\\\\\\\|"]
  @@card_rows = [[], [], [], [], [], []]

  attr_reader :suit, :value
  attr_accessor :points

  def initialize(suit, value)
    @suit = suit
    @value = value
    @points = calculate_points
  end

  def to_s
    "#{value} #{suit_symbol}"
  end

  def draw_hidden
    @@card_rows[0] << HIDDEN_CARD[0]
    @@card_rows[1] << HIDDEN_CARD[1]
    @@card_rows[2] << HIDDEN_CARD[2]
    @@card_rows[3] << HIDDEN_CARD[3]
    @@card_rows[4] << HIDDEN_CARD[4]
    @@card_rows[5] << HIDDEN_CARD[5]
  end

  def draw_visible
    @@card_rows[0] << " _________ "
    if value == '10'
      @@card_rows[1] << "#{value}        |"
      @@card_rows[2] << "|         |"
      @@card_rows[3] << "|    #{suit_symbol}    |"
      @@card_rows[4] << "|         |"
      @@card_rows[5] << "|________#{value}"
    else
      @@card_rows[1] << "|#{value}        |"
      @@card_rows[2] << "|         |"
      @@card_rows[3] << "|    #{suit_symbol}    |"
      @@card_rows[4] << "|         |"
      @@card_rows[5] << "|________#{value}|"
    end
  end

  def self.reset_card_rows
    @@card_rows = [[], [], [], [], [], []]
  end

  def self.draw_full_hand
    @@card_rows.each { |row| print_centered(row.join(' ')) }
    Card.reset_card_rows
  end

  private

  def calculate_points
    if number_card?
      value.to_i
    elsif face_card?
      10
    else
      11
    end
  end

  def number_card?
    !('A'..'Z').include?(value)
  end

  def face_card?
    %w(J Q K).include?(value)
  end

  def suit_symbol
    case suit
    when 'C' then "\u2663"
    when 'S' then "\u2660"
    when 'H' then "\u2665"
    when 'D' then "\u2666"
    else          suit
    end
  end

end

class Participant
  attr_accessor :hand, :total, :name, :score

  def initialize
    @hand = []
    @score = 0
    set_name
  end

  def hit(card)
    hand << card
    calculate_total
  end

  def busted?
    total > TwentyOneGame::POINTS_UPPER_LIMIT
  end

  def calculate_total
    self.total = 0
    hand.each { |card| self.total += card.points }
    correct_for_aces
  end

  private

  def correct_for_aces
    hand.count { |card| card.value == 'A' }.times do
      self.total -= 10 if busted?
    end
  end
end

class Dealer < Participant
  include Printable

  DEALER_STAYS = 17
  DEALERS = ['Hal', 'Deep Thought', 'Skynet', 'Robbie', 'R2D2', 'C3PO']

  def set_name
    self.name = DEALERS.sample
  end

  def display_hand
    print_centered "==========> #{name} <=========="
    hand.each_with_index do |card, index|
      if index == 0
        card.draw_hidden
      else
        card.draw_visible
      end
    end
    Card.draw_full_hand
    puts ""
  end
end

class Player < Participant
  include Printable

  def get_move
    answer = nil
    print_centered "Would you like to (h)it or (s)tay?"
    set_margin
    loop do
      answer = gets.chomp.downcase
      break if %w(h s).include? answer
      print_centered "Please enter 'h' or 's'."
      set_margin
    end

    answer
  end

  def set_name
    print_centered "What's your name? "
    set_margin
    loop do
      self.name = gets.chomp
      break if !name.empty?
      print_centered "Please enter a name."
      set_margin
    end
  end

  def display_hand
    print_centered "==========> #{name} <=========="
    hand.each do |card|
      card.draw_visible
    end
    Card.draw_full_hand
    puts ""
    print_centered "Current Total: #{total}"
  end
end

class TwentyOneGame
  include Printable

  POINTS_UPPER_LIMIT = 21
  ROUNDS_TO_WIN = 5

  attr_accessor :deck
  attr_reader :dealer, :player

  def initialize
    clear
    expand_window if window_too_small?
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def play
    display_welcome
    loop do
      play_single_round
      display_grand_winner
      break unless play_again?
      reset_tournament
    end
    display_goodbye
  end

  private

  def display_welcome
    clear
    print_centered "\u2663 \u2660 \u2665 \u2666"
    puts ""
    print_centered "Hi #{player.name}!"
    print_centered "Welcome to #{POINTS_UPPER_LIMIT}!"
    puts ""
    print_centered "Get as close to #{POINTS_UPPER_LIMIT} as possible, " \
         "without going over."
    puts ""
    print_centered "Cards 2-10 are each worth their face value."
    print_centered "Jacks, Queens, and Kings are all worth 10."
    print_centered "An Ace can be worth either 11 or 1."
    puts ""
    print_centered "Tell the dealer 'hit' to get another card."
    print_centered "Choose to 'stay' to try your luck with what you've got."
    print_centered "If you go over #{POINTS_UPPER_LIMIT} you 'bust' and" \
         " the dealer wins!"
    puts ""
    print_centered "Your dealer today will be #{dealer.name}."
    print_centered "The first player to win #{ROUNDS_TO_WIN} games wins!"
    puts ""
    print_centered "\u2663 \u2660 \u2665 \u2666"
    puts ""
    print_centered "Hit enter to begin. Good luck!"
    set_margin
    start = gets.chomp
  end

  def play_single_round
    loop do
      clear
      deal_initial_cards
      show_cards
      player_turn
      dealer_turn unless player.busted?
      update_score
      show_result
      break if someone_won_tournament?
      quit_early unless play_again?
      reset
    end
  end

  def deal_initial_cards
    2.times { dealer.hand << deck.deal_single_card! }
    dealer.calculate_total
    2.times { player.hand << deck.deal_single_card! }
    player.calculate_total
  end

  def show_cards
    print_centered "==========> SCORE <=========="
    puts ""
    print_centered "#{player.name} - #{player.score} #{dealer.name} - #{dealer.score}"
    puts ""
    dealer.display_hand
    player.display_hand
    puts ""
  end

  def player_turn
    loop do
      break if player.busted?
      case player.get_move
      when 'h' then player.hit(deck.deal_single_card!)
      when 's' then break
      end
      clear
      show_cards
    end
    print_centered "BUST!!" if player.busted?
    puts ""
  end

  def dealer_turn
    while dealer.total < Dealer::DEALER_STAYS
      dealer.hit(deck.deal_single_card!)
      clear
      show_cards
      sleep(1)
      if dealer.busted?
        print_centered "#{dealer.name.upcase} BUSTS!!"
        puts ""
        break
      end
    end
  end

  def update_score
    if player.busted? || (dealer.total > player.total && !dealer.busted?)
      dealer.score += 1
    elsif dealer.busted? || (player.total > dealer.total && !player.busted?)
      player.score += 1
    end
  end

  def show_result
    if player.busted? || dealer.busted?
      show_busted_result
    else
      print_centered "Both players have stayed."
      puts ""
      print_centered "#{dealer.name} has #{dealer.total} #{player.name} has #{player.total}"
      display_winner
    end
    puts ""
    print_centered "The score is now: #{player.name} - #{player.score} " \
         "#{dealer.name} - #{dealer.score}"
    puts ""
  end

  def display_winner
    if player.total > dealer.total && !player.busted?
      print_centered "#{player.name} wins!"
    elsif dealer.total > player.total && !dealer.busted?
      print_centered "#{dealer.name} wins!"
    elsif player.total == dealer.total
      print_centered "It's a tie!"
    end
  end

  def show_busted_result
    if player.busted?
      print_centered "#{player.name} busted! #{dealer.name} wins!"
    else
      print_centered "#{dealer.name} busted! #{player.name} wins!"
    end
  end

  def someone_won_tournament?
    player.score >= ROUNDS_TO_WIN || dealer.score >= ROUNDS_TO_WIN
  end

  def display_grand_winner
    puts ""
    if player.score > dealer.score
      print_centered "#{player.name} is the grand winner!!"
    else
      print_centered "#{dealer.name} is the grand winner!!"
    end
    puts ""
  end

  def play_again?
    answer = nil
    print_centered "Would you like to play again? (y/n)"
    set_margin
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      print_centered "Please enter 'y' or 'n'"
      set_margin
    end

    answer == 'y'
  end

  def reset
    self.deck = Deck.new
    player.hand = []
    dealer.hand = []
  end

  def reset_tournament
    reset
    player.score = 0
    dealer.score = 0
  end

  def display_goodbye
    print_centered "Thank you for playing #{POINTS_UPPER_LIMIT}! Goodbye!"
    sleep(2)
    clear
  end

  def quit_early
    display_goodbye
    sleep(2)
    clear
    exit
  end
end

TwentyOneGame.new.play