# Collaborator Objects

A **collaborator object** is an object that is stored as a _state_ (i.e. within an instance variable) within another object. The are called _collaborators_ because they work in conjunction with the class they are associated with.

Collaborator objects are usually _custom_ objects (i.e. defined by programmer and not built into Ruby). Technically, a string or other built in object type that's saves as a value in an instance variable would still be a collaborator object but we don't really tend to think of them that way.

Collaborator objects _represent the connections between various actors in the program_. When thinking about how to structure your various classes, objects, and all the ways in which they might connect, think about:

- What collaborators will a custom class need?
- Do the associations between a custom class and its collaborators make sense?
- What makes sense here technically?
- What makes sense here with respect to modeling the problem we are attempting to solve?

At the end of the day, collaborator objects allow us to chop up and modularize the problem domain into cohesive pieces.

## Example 1

A `Library` is a class representing a collection of `Book` objects.

```ruby
class Library
  attr_accessor :books

  def initialize
    @books = []
  end

  def <<(book)
    books.push(book)
  end

  def checkout_book(title, author)
    book = Book.new(title, author)
    if books.include?(book)
      books.delete(book_to_checkout)
    else
      puts "The library does not have that book"
    end
  end
end

class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title = title
    @author = author
  end

  def to_s
    "#{title} by #{author}"
  end

  def ==(other)
    title == other.title && author == other.author
  end
end

lib = Library.new

lib << Book.new('Great Expectations', 'Charles Dickens')
lib << Book.new('Romeo and Juliet', 'William Shakespeare')
lib << Book.new('Ulysses', 'James Joyce')

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Romeo and Juliet by William Shakespeare
  # => Ulysses by James Joyce

lib.checkout_book('Romeo and Juliet', 'William Shakespeare')
  # deletes the Romeo and Juliet book object from @books and returns it

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Ulysses by James Joyce

lib.checkout_book('The Odyssey', 'Homer')
  # => The library does not have that book
```

First we initialize our `Library` object. When this object is instantiated, the `@books` instance variable is initialized as well and assigned to an empty array. We are going to use the array as a way to facilitate our collection implementation, so that the `Library` class can internally rely on the `Array` interface to manipulate the collection of `Book` objects. Technically, the array here would be a collaborator object, however, the relationship between `Array` and `Library` is not really meaningful in terms of the program design.

Next, we add three instances of `Book` to the `Library` object. We've defined an `<<` method in `Library` to facilitate the addition of each `Book` object to the `@books` array such that we can utilize Ruby's syntactical sugar and not really worry about the internal mechanics of how each `Book` is getting added to the `Library` instance. This is an example of [encapsulation](./polymorphism_encapsulation.md#encapsulation).

We can call the `Array#each` method on the value returned by the getter method `books` in order to output each `Book` object as a string. Doing so shows us that each `Book` instance has indeed been added to our `Library` collection object.

The `Book` instances here are what we are concerned with when we say _collaborator objects_. We consider these to be collaborators because they are separate object with a separate interface that has been added to an attribute of `Library`. Further, the `Book` interface interacts meaningfully with the `Library` implementation, allowing us to access that interface without necessarily needed to know about it through our manipulations of the `Library` instance outside the class.

Next, we call the `checkout_book` method and pass it the arguments `'Romeo and Juliet'` and `'William Shakespeare'`. Within the `checkout_book` implementation we perhaps have our most interesting interaction between `Library` and `Book`. We know we are searching through an array of `Book` objects, so first we instantiate a new `Book` with the arguments given. Then, the method checks to see if the `Library` has the book (using `Array#include?`). If it does, it removes that book object (which we can do having defined a custom `Book#==` method) and returns it. If the book is not found, the method will output a message to the user saying that the library does not have that particular book.

In this case, the `Book` with the title `'Romeo and Juliet'` is found, removed, and returned. We can verify this by again outputting all the books in the `Library` by calling `each` on the value returned by `books`. At this point, this will only output two books, _Great Expectations_ and _Ulysses_.

Finally, we test out our guard clause by trying to check out a book the library does not have. `checkout_book` executes as expected and the string `'The library does not have that book'` is output.

We say that the relationship between `Book` and `Library` here is one of _collaboration_ because a library _has_ books. Which books the library contains and what they are called is an aspect of it's _state_. Therefore, the relationship of inheritance would not be appropriate here.

## Example 2

A `Deck` is a class representing a collection of `Card` objects

```ruby
class Deck
  attr_accessor :cards
  
  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end
    
    cards.shuffle!
  end
  
  def deal_one_card
    cards.pop
  end
end

class Card
  SUITS = %w(Hearts Clubs Diamonds Spades)
  VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  
  attr_accessor :suit, :value
  
  def initialize(suit, value)
    @suit = suit
    @value = value
  end
  
  def to_s
    "The #{value} of #{suit}"
  end
end

deck = Deck.new

hand = []

5.times { hand << deck.deal_one_card }
  
hand.each { |card| puts card }
  # => The 10 of Diamonds
  # => The Queen of Clubs
  # => The 10 of Spades
  # => The Jack of Clubs
  # => The 8 of Diamonds
  # (cards are randomly selected, output may differ)
```

In the above code, we define our `Deck` class to work with the collaborator object `Card`. When a new `Deck` instance is initialized, the `Deck` class relies on the `Card` class constants `SUITS` and `VALUES` to generate a new 52 card deck.

The `Deck` instance in this case is really a vehicle for manipulating and organizing `Card` objects. While it may utilize the `Card` attributes of `suit` and `value`, it isn't really concerned with them in the way that a `Card` object might be.

Because the `Card` objects are assigned to one of the `Deck` attributes (the instance variable `@cards`) we say that the `Card` instances here are _collaborator objects_ that work intrinsically with `Deck`.
