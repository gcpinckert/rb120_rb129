=begin
Create an object-oriented number guessing class for numbers 1-100
Limit to 7 guesses per game
A game object should start a new game with a new number with .play

# Example
game = GuessingGame.new
game.play

You have 7 guesses remaining.
Enter a number between 1 and 100: 104
Invalid guess. Enter a number between 1 and 100: 50
Your guess is too low.

You have 6 guesses remaining.
Enter a number between 1 and 100: 75
Your guess is too low.

You have 5 guesses remaining.
Enter a number between 1 and 100: 85
Your guess is too high.

You have 4 guesses remaining.
Enter a number between 1 and 100: 0
Invalid guess. Enter a number between 1 and 100: 80

You have 3 guesses remaining.
Enter a number between 1 and 100: 81
That's the number!

You won!

game.play

You have 7 guesses remaining.
Enter a number between 1 and 100: 50
Your guess is too high.

You have 6 guesses remaining.
Enter a number between 1 and 100: 25
Your guess is too low.

You have 5 guesses remaining.
Enter a number between 1 and 100: 37
Your guess is too high.

You have 4 guesses remaining.
Enter a number between 1 and 100: 31
Your guess is too low.

You have 3 guesses remaining.
Enter a number between 1 and 100: 34
Your guess is too high.

You have 2 guesses remaining.
Enter a number between 1 and 100: 32
Your guess is too low.

You have 1 guesses remaining.
Enter a number between 1 and 100: 32
Your guess is too low.

You have no more guesses. You lost!

# Algorithm
- Initialize game each time .play is called
  - A new number to guess
  - Reset number of guesses to 7
- Steps for each round
  - Display the number of guesses remaining
  - Ask the user to enter a number 1-100
  - Validate user input (if not a number 1-100, ask again)
  - Tell user if their guess is too high or too low
  - If the user guesses the number, display winning message
  - If the user runs out of guesses, display losing message
  - Decrement number of guesses with each guess
=end

class GuessingGame
  RANGE = (1..100).to_a
  MAX_GUESSES = 7

  attr_accessor :guesses, :guess
  attr_reader :number

  def initialize
    @guesses = MAX_GUESSES
    @number = generate_number
  end

  def play
    #clear
    loop do
      show_remaining_guesses
      self.guess = ask_valid_number
      break if number_guessed?
      show_over_under
      self.guesses -= 1
      break if out_of_guesses?
    end
    show_results
    reset
  end

  private

  def clear
    system "clear"
  end

  def generate_number
    RANGE.sample
  end

  def reset
    @guesses = MAX_GUESSES
    @number = generate_number
  end

  def show_remaining_guesses
    puts "You have #{guesses} guesses remaining."
  end

  def ask_valid_number
    answer = nil
    loop do
      print "Enter a number between #{RANGE.first} and #{RANGE.last}: "
      answer = gets.chomp
      break if valid_number?(answer)
      puts "Invalid guess. "
    end

    answer.to_i
  end

  def valid_number?(str)
    str =~ /\A[-+]?\d+\z/ && RANGE.include?(str.to_i)
  end

  def number_guessed?
    guess == number
  end

  def show_over_under
    if guess < number
      puts "Your guess is too low."
    elsif guess > number
      puts "Your guess is too high."
    end
  end

  def out_of_guesses?
    guesses == 0
  end

  def show_results
    if number_guessed?
      puts "That's the number!"
      puts ""
      puts "You won!"
    elsif out_of_guesses?
      puts "You have no more guesses. You lost!"
    end
  end
end

game = GuessingGame.new
game.play
game.play
