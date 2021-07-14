=begin
Using the Card class from 08.rb, create a Deck class that contains all of the 
standard 52 playing cards. 
- Provide a #draw method to deal one card
- Shuffle the deck when it is initialized
- If it runs out of cards, the deck should reset itself by generating a new
  set of 52 cards, shuffled

# Approach
- Create two constants for SUIT and PIP
- Initialize the deck by iterating through SUITS
  - Iterate through PIPS
    - Add a new Card object with (PIP, SUIT) to the deck
- Once the deck contains all the cards, shuffle the deck

- The draw method should return the first card in the deck, and remove it

- Define a reset method that performs the initialization functions again
=end

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
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other_card)
    RANKS.index(rank) <=> RANKS.index(other_card.rank)
  end

  def ==(other_card)
    RANKS.index(rank) == RANKS.index(other_card.rank)
  end

end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.
