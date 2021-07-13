# Assignment: OO Twenty One

## Rules of Twenty-One

- Played with a normal 52-card deck.
- Deck consists of 4 suits: hearts, diamonds, clubs, and spades
- Each suit has 13 values: 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A
- Goal: get your hand as close to 21 points as possible, without going over
- If you go over 21, it's a 'bust' and you lose
- The game has a 'dealer' and a 'player'
- Both participants are initially dealt 2 cards
- The player can see both of their own cards, but only 1 of the dealer's cards
- Card values:
  - 2-10: all worth their face value
  - J, Q, K: all worth 10
  - A: worth 11, unless that makes the hand bust, in which case it is worth 1
  - The ace's value is determined each time a new card is drawn from the deck
  - Multiple aces in a hand must be accounted for separately when calculating the score
  - For example, 2 + 5 + A = 2 + 5 + 11 totalling 18, but 2 + 5 + A + A = 2 + 5 + 11 + 1 totalling 19, because the second ace would cause the hand to bust if it counted as 11 points.
- Player's turn
  - Player goes first
  - Decides whether to 'hit' or to 'stay'
  - 'hit' means the player gets dealt a new card from the deck
  - If the total goes over 21, the player busts and looses
  - The decision to hit or stay is based on what the player's cards re and what the player thinks the dealer has.
  - If the player has a low score, they have a low chance of busting, so probably want to hit. If the player has a higher score, the chances of busting are increased, so they may want to stay
  - The player can continue to hit as many times as they want.
  - The turn is over when the player either busts or stays
  - If the player busts, the game is over and the dealer wins
- Dealer's turn
  - The dealer's turn begins when the player stays
  - The dealer always hits until the total is greater than or equal to 17, then chooses to stay
  - If the dealer busts, the player wins
- If neither player busts, the total value of the cards in each hand must be compared
- The winner is the player whose hand has the highest value

## Examples of Gameplay

1. Dealer: Ace and unknown card You: 2 and 8
    In this scenario the player should hit. Because the dealer has an ace, there is a strong probability they have exactly 21, or very close to it. Further, your total of 10 currently has no way to bust, so a hit can only benefit you.

2. Dealer: 7 and unknown card You: 10 and 7
    Here you should stay. Chances are good that the unknown card is not an ace, which in this case is the only hand that will beat your total of 17.

3. Dealer: 5 and unknown card You: Jack and 6
    The best choice here is to stay, and hope the dealer will bust. This is because the highest score the dealer may have is a 15, which means he must hit, and there's a good chance he will bust.

## Nouns and Verbs

Nouns: card, player, dealer, deck, game, total
Verbs: deal, hit, stay busts

Note: _total_ is a proprty of some other noun, not a noun that can perform any actions (can also be thought of as a verb _calculate total_).

Note: busts is not an action being performed. In fact, it represents a state, _busted?_

Potential Classes

```
Player
- hit
- stay
- busted?
- total
Dealer
- hit
- stay
- busted?
- total
- deal (should this be here, or in Deck?)
Deck
- deal (should this be here, or in Dealer?)
Card
Game
- start / play
```

Notice the redundancy in both Player and Dealer. We can extract that redundancy into a superclass (what to call it?). We can also introduce a module called `Hand` that will encapsulate these behaviors and make them available across classes regardless of inheritance.

## Spike

```ruby
class Player
  def initialize
    # what attributes or states does the Player object need?
    # the cards they hold? a name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # we need to know about cards to produce total
  end
end

class Dealer
  def initialize
    # same as player? create superclass?
  end

  def deal
    # does dealer or deck deal?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
  # superclass for player and dealer?
  # redundant behaviors for each?
end

class Deck
  def initialize
    # data structure to keep track of cards
  end

  def deal
    # does dealer or deck deal?
  end
end

class Card
  def initialize
    # what are the attributes of a card?
    # it's score / value?
  end
end

class Game
  def start
    # what's the sequence of steps to execute gameplay?
    deal_card
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start
```
