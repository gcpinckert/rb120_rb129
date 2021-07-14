=begin
Update the solution in 06.rb to accept a low and high value when you create
a guessing game object.
Use those values to compute a secret number for the game
Change the number of guesses allowed so the user can always win
Compute the number of guesses with: Math.log2(size_of_range).to_i + 1

# Examples:
game = GuessingGame.new(501, 1500)
game.play

You have 10 guesses remaining.
Enter a number between 501 and 1500: 104
Invalid guess. Enter a number between 501 and 1500: 1000
Your guess is too low.

You have 9 guesses remaining.
Enter a number between 501 and 1500: 1250
Your guess is too low.

You have 8 guesses remaining.
Enter a number between 501 and 1500: 1375
Your guess is too high.

You have 7 guesses remaining.
Enter a number between 501 and 1500: 80
Invalid guess. Enter a number between 501 and 1500: 1312
Your guess is too low.

You have 6 guesses remaining.
Enter a number between 501 and 1500: 1343
Your guess is too low.

You have 5 guesses remaining.
Enter a number between 501 and 1500: 1359
Your guess is too high.

You have 4 guesses remaining.
Enter a number between 501 and 1500: 1351
Your guess is too high.

You have 3 guesses remaining.
Enter a number between 501 and 1500: 1355
That's the number!

You won!

game.play
You have 10 guesses remaining.
Enter a number between 501 and 1500: 1000
Your guess is too high.

You have 9 guesses remaining.
Enter a number between 501 and 1500: 750
Your guess is too low.

You have 8 guesses remaining.
Enter a number between 501 and 1500: 875
Your guess is too high.

You have 7 guesses remaining.
Enter a number between 501 and 1500: 812
Your guess is too low.

You have 6 guesses remaining.
Enter a number between 501 and 1500: 843
Your guess is too high.

You have 5 guesses remaining.
Enter a number between 501 and 1500: 820
Your guess is too low.

You have 4 guesses remaining.
Enter a number between 501 and 1500: 830
Your guess is too low.

You have 3 guesses remaining.
Enter a number between 501 and 1500: 835
Your guess is too low.

You have 2 guesses remaining.
Enter a number between 501 and 1500: 836
Your guess is too low.

You have 1 guesses remaining.
Enter a number between 501 and 1500: 837
Your guess is too low.

You have no more guesses. You lost!
=end

class GuessingGame
  attr_accessor :guesses, :guess
  attr_reader :number, :range

  def initialize(low, high)
    @range = (low..high).to_a
    @guesses = calculate_guesses
    @number = generate_number
  end

  def play
    loop do
      puts ""
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

  def calculate_guesses
    Math.log2(range.size).to_i + 1
  end

  def generate_number
    range.sample
  end

  def reset
    @guesses = calculate_guesses
    @number = generate_number
  end

  def show_remaining_guesses
    puts "You have #{guesses} guesses remaining."
  end

  def ask_valid_number
    answer = nil
    loop do
      print "Enter a number between #{range.first} and #{range.last}: "
      answer = gets.chomp
      break if valid_number?(answer)
      puts "Invalid guess. "
    end

    answer.to_i
  end

  def valid_number?(str)
    str =~ /\A[-+]?\d+\z/ && range.include?(str.to_i)
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

game = GuessingGame.new(501, 1500)
game.play
game.play
