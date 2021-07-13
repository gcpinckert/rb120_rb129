module Printable
  def clear
    system("clear") || system("cls")
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
  attr_accessor :hand, :total, :name

  def initialize
    @hand = []
    @total = 0
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
  DEALER_STAYS = 17
  DEALERS = ['Hal', 'Deep Thought', 'Skynet', 'Robbie', 'R2D2', 'C3PO']

  def set_name
    self.name = DEALERS.sample
  end

  def display_hand
    puts "==========> #{name} <=========="
    hand.each_with_index do |card, index|
      if index == 0
        puts "||#{card}||"
      else
        puts "|||||||"
      end
    end
    puts ""
  end
end

class Player < Participant
  def get_move
    answer = nil
    loop do
      puts "Would you like to (h)it or (s)tay?"
      answer = gets.chomp.downcase
      break if %w(h s).include? answer
      puts "Please enter 'h' or 's'."
    end

    answer
  end

  def set_name
    loop do
      puts "What's your name? "
      self.name = gets.chomp
      break if !name.empty?
      puts "Please enter a name."
    end
  end

  def display_hand
    puts "==========> #{name} <=========="
    hand.each do |card|
      puts "||#{card}||"
    end
    puts ""
    puts "Current Total: #{total}"
  end
end

class TwentyOneGame
  include Printable

  POINTS_UPPER_LIMIT = 21

  attr_accessor :deck
  attr_reader :dealer, :player

  def initialize
    clear
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def play
    display_welcome
    loop do
      clear
      deal_initial_cards
      show_cards
      player_turn
      dealer_turn unless player.busted?
      show_result
      break unless play_again?
      reset
    end
    display_goodbye
  end

  private

  def display_welcome
    puts "Hi #{player.name}! Welcome to #{POINTS_UPPER_LIMIT}!"
    puts "Get as close to #{POINTS_UPPER_LIMIT} as possible, " \
         "without going over."
    puts ""
    puts "Cards 2-10 are each worth their face value."
    puts "Jacks, Queens, and Kings are all worth 10."
    puts "An Ace can be worth either 11 or 1."
    puts ""
    puts "Tell the dealer 'hit' to get another card."
    puts "Choose to 'stay' to try your luck with what you've got."
    puts "If you go over #{POINTS_UPPER_LIMIT} you 'bust' and" \
         " the dealer wins!"
    puts ""
    puts "Your dealer today will be #{dealer.name}."
    puts "Hit enter to begin. Good luck!"
    start = gets.chomp
  end

  def deal_initial_cards
    2.times { dealer.hand << deck.deal_single_card! }
    dealer.calculate_total
    2.times { player.hand << deck.deal_single_card! }
    player.calculate_total
  end

  def show_cards
    dealer.display_hand
    player.display_hand
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
    puts "BUST!!" if player.busted?
  end

  def dealer_turn
    while dealer.total < Dealer::DEALER_STAYS
      dealer.hit(deck.deal_single_card!)
      if dealer.busted?
        puts "#{dealer.name.upcase} BUSTS!!"
        break
      end
    end
  end

  def show_result
    if player.busted? || dealer.busted?
      show_busted_result
    else
      puts "Both players have stayed."
      puts "#{dealer.name} has #{dealer.total} #{player.name} has #{player.total}"
      display_winner
    end
  end

  def display_winner
    if player.total > dealer.total && !player.busted?
      puts "#{player.name} wins!"
    elsif dealer.total > player.total && !dealer.busted?
      puts "#{dealer.name} wins!"
    end
  end

  def show_busted_result
    if player.busted?
      puts "#{player.name} busted! #{dealer.name} wins!"
    else
      puts "#{dealer.name} busted! #{player.name} wins!"
    end
  end

  def play_again?
    answer = nil
    puts "Would you like to play again? (y/n)"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Please enter 'y' or 'n'"
    end

    answer == 'y'
  end

  def reset
    self.deck = Deck.new
    player.hand = []
    dealer.hand = []
  end

  def display_goodbye
    puts "Thank you for playing #{POINTS_UPPER_LIMIT}! Goodbye!"
  end
end

TwentyOneGame.new.play