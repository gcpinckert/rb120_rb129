=begin
Update the given Card class so it can be used to determine levels of rank
- Numeric cards are low ordered 2-10
- 10 < J < Q < K < A
- Suit does not effect card rank
- If an array contains two cards of matchin rank, min or max should return one of them
- Create a to_s method that returns a string like "Jack of Diamonds"

# Algorithm:
- Create a public to_s method that outputs a string representation of the card
- Define comparison methods that compares the value we are interested in
- Define min and max methods based on those comparison methods
- Define a method to evalutate equivalence
- Define a rank method that returns the rank of the card
  - Should be integer for number cards or string for face cards
- Create a constant array of the order of ranks
  - We can refer to index of this constant when performing comparison and sorting
=end

class Card
  RANK_ORDER = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other_card)
    RANK_ORDER.index(rank) <=> RANK_ORDER.index(other_card.rank)
  end

  def ==(other_card)
    RANK_ORDER.index(rank) == RANK_ORDER.index(other_card.rank)
  end
end

cards = [Card.new(2, 'Hearts'),
  Card.new(10, 'Diamonds'),
  Card.new('Ace', 'Clubs')]
puts cards
  # => 2 of Hearts
  # => 10 of Diamonds
  # => Ace of Clubs
puts cards.min == Card.new(2, 'Hearts')     # true
puts cards.max == Card.new('Ace', 'Clubs')  # true

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')     # true
puts cards.max == Card.new(5, 'Hearts')     # true

cards = [Card.new(4, 'Hearts'),
  Card.new(4, 'Diamonds'),
  Card.new(10, 'Clubs')]
puts cards.min.rank == 4                    # true
puts cards.max == Card.new(10, 'Clubs')     # true

cards = [Card.new(7, 'Diamonds'),
  Card.new('Jack', 'Diamonds'),
  Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')   # true
puts cards.max.rank == 'Jack'               # true

cards = [Card.new(8, 'Diamonds'),
  Card.new(8, 'Clubs'),
  Card.new(8, 'Spades')]
puts cards.min.rank == 8                    # true
puts cards.max.rank == 8                    # true

