# Assignment: OO Tic Tac Tow

## Object Oriented Design Approach

1. Write a description of the problem an extract major nouns and verbs.
2. Make an initial guess at organizing the verbs into nouns and do a **spike** to explore the problem with temporary code.
3. Optional - when you have a better idea of the problem, model your thoughts into CRC cards.

### Nouns and Verbs

Tic Tac Toe Game Description

Tic Tac Tow is a 2-player board game played on a 3x3 grid. Players take turns marking a square. The first player to mark 3 squares in a row wins.

Nouns: board, player, square, grid (board and grid reference the same thing)
Verbs: play, mark

- Board
- Square
- Player
  - mark
  - play

### Potential Classes

```ruby
class Board
  def initialize
    # some way to model the 3x3 grid. `squares`?
    # data structure?
    # - array / hash of Square objects?
    # - array / hash of strings or ints?
  end
end

class Square
  def initialize
    # 'status' to keep track of the square's marker?
  end
end

class Player
  def initialize
    # maybe a 'marker' to keep track of Player's symbol?
    # X or O
  end

  def mark
    # implement a way to mark a Square with proper symbol
  end

  def play
    # implement a way for the player to play the game
  end
end
```

Make sure we have a class for a __basic orchestration engine__. This should contain the `play` method that we previously categorized with `Player`.

```ruby
class TTTGame
  def play

  end
end

# initialize a new game
game = TTTGame.new
game.play
```

### Game Play

What methods do we need to define in order to make sure the game works?

```ruby
class TTTGame
  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end
    display_result
    display_goodbye
  end
end
```
