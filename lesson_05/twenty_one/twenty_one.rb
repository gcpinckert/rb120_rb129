require 'pry'

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
    end
  end

end

class Participant
  POINTS_UPPER_LIMIT = 21

  attr_accessor :hand, :total

  def initialize
    @hand = []
    @total = 0
  end

  def hit(card)
    hand << card
    self.total += card.points
    correct_for_aces
  end

  def stay
  end

  def busted?
    total > POINTS_UPPER_LIMIT
  end

  def calculate_total
    hand.each { |card| self.total += card.points }
    correct_for_aces
    total
  end

  def correct_for_aces
    hand.count { |card| card.value == 'A' }.times do
      self.total -= 10 if busted?
    end
  end
end

class Dealer < Participant
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
end

class TwentyOneGame
  DEALER_STAYS = 17

  attr_accessor :deck
  attr_reader :dealer, :player

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def play
    binding.pry
    deal_initial_cards
    show_cards
    player_turn
    dealer_turn unless player.busted?
    show_result
  end

  private

  def deal_initial_cards
    2.times { dealer.hand << deck.deal_single_card! }
    dealer.calculate_total
    2.times { player.hand << deck.deal_single_card! }
    player.calculate_total
  end

  def show_cards
    puts "Dealer has #{dealer.hand[0]} and an unknown card."
    puts "You have #{player.hand.join(' and ')}."
    puts "Your total is #{player.total}."
  end

  def player_turn
    loop do
      break if player.busted?
      case player.get_move
      when 'h' then player.hit(deck.deal_single_card!)
      when 's' then player.stay; break
      end
      show_cards
    end
    puts "BUST!!" if player.busted?
  end

  def dealer_turn
    while dealer.total < DEALER_STAYS
      dealer.hit(deck.deal_single_card!)
      if dealer.busted?
        puts "DEALER BUSTS!!"
        break
      end
    end
  end

  def show_result
    puts "Dealer has #{dealer.total} You have #{player.total}"
  end
end

TwentyOneGame.new.play