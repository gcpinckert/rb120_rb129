=begin
Use the Card and Deck class from 08.rb and 09.rb to create and evaluate
poker hands. Create a class PokerHand that:
  - takes 5 cards from a Deck of Cards
  - evaluates those cards as a Poker hand

# Approach:
- #print should output each card as a string on an individual line
- #evaluate should return a string representation of the hand type

- #royal_flush? = A,K,Q,J,10 all the same suit
  - Check to see if all suits in the array of cards are the same
  - Check to see if the values of each card add up to 55
    (this shows they are all the highest cards)

- #straight_flush? = all values in sequence, all the same suit
  - Check to see if all the suits in the array are the same
  - Sort the array of cards
  - Iterate from the index associated with the lowest card up to the highest
    - If the index of the current card does not match with the ref index
    - return false

- Extract flush logic to #flush? method
- Extract straight logic to #striaght? method

- #four_of_a_kind? = four cards with same rank
  - Iterate through the cards count the times each rank appears in the hand
  - If the count is ever 4, return true
  - Otherwise, return false

- #three_of_a_kind? = three cards with the same rank
  - Do as above but with a count of 3

- #full_house? = 3 of a kind? + a pair
  - Do as above but with a count of 3 and also a count of 2

- #flush? = all the same suit, not in sequence
  - Flush logic but also include !straight?

- #straight? = sequence, not same suit
  - straight logic but include !flush?

- #two_pair? = two different pairs
  - Initialize a counter to 0
  - Iterate through the cards counting each time a rank appears in a hand
  - If the rank appears twice, increment the counter
  - If the counter is 2, return true

- Pair
  - Iterate for rank and if it appears twice return true
=end
require 'pry'

class Deck
  def initialize
    @cards = []
    set_up_deck
  end

  def draw
    set_up_deck if cards.empty?
    cards.pop
  end

  private

  attr_reader :cards

  def set_up_deck
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end

    cards.shuffle!
  end
end

class Card
  SUITS = ['Hearts', 'Diamonds', 'Clubs', 'Spades']
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
  attr_reader :rank, :suit, :value

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = RANKS.index(rank)
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  def ==(other_card)
    value == other_card.value
  end

end


class PokerHand
  def initialize(deck)
    @cards = []
    5.times { cards << deck.draw }
  end

  def print
    cards.each { |card| puts card }
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  attr_reader :cards

  def royal_flush?
    flush? && add_values == 50
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    n_of_a_kind?(4)
  end

  def full_house?
    n_of_a_kind?(3) && n_of_a_kind?(2)
  end

  def flush?
    cards.all? { |card| card.suit == cards[0].suit }
  end

  def straight?
    sorted = cards.sort
    sorted.each_with_index do |card, idx|
      next if idx == 0
      previous_card_value = sorted[idx - 1].value
      return false unless card.value == (previous_card_value + 1)
    end

    true
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_pair?
    counter = 0
    cards.each do |card_to_check|
      if (cards.count do |card| 
          card.value == card_to_check.value
        end) == 2
          counter += 1
      end
    end

    counter /= 2
    counter == 2
  end

  def pair?
    n_of_a_kind?(2)
  end

  def add_values
    sum = 0
    cards.each do |card|
      sum += card.value
    end
    sum
  end

  def n_of_a_kind?(num)
    cards.each do |card_to_check|
      if (cards.count do |card| 
          card.value == card_to_check.value
        end) == num
          return true
      end
    end

    false
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'