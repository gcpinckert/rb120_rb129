# TA Led Study Session - July 21, 2021

## Intro

- Assessment format and focus
- What are we trying to asses? (differences from 109)
- Work through practice questions
  - conceptual open ended
  - code based
- General questions

## Assessment Focus

- High level of abstraction compared to 109
- A lot more complexity in terms of what's going on in the background

```ruby
class Person
attr_accessor :name

  def introduce
    puts "Hi, my name is #{name}"
  end
end

karl = Person.new
karl.name = 'Karl'
karl.introduce
```

- What are your mental models / understanding of all the abstractions?

## Assessment Format

- The written and interview are much more similar than 109
- Both are about explaining the abstract concepts
- In the written you have to explain in writing, in the interview you have to explain orally
- The list of topics for the written also apply to the interview
- Be able to produce code examples
- Explanations an code examples working together
- Conceptual questions ask you to explain things like "what's polymorphism?" "explain how inheritance works?", explain these things on a theoretical level
- Interview: much more back and forth, a lot more like a conversation
- Code based questions like "what will happen if you run this code?" and you have to run through explaining your mental models, from your conceptual understanding coming up with the answer
- We want to produce this output when we run this code, update the code so we get the expected result
- Questions might have a different level of focus. i.e. answer some of them in 1-2 sentences but others might require a more involved answer.
- Make sure you have enough time to deal with the questions that might take longer!
- Keep your examples simple! Do not use long complex examples if you can help it. It adds clarity to your explanation and takes less time.
- Questions will be deceptively simple. Short but containing multitudes.
- Be able to drill down into the specific concepts being demonstrated.
- Apply your conceptual understanding to your reading of the code.

## Prep

- Medium article with detailed subject matter for RB129 written.
- Templates for different question answers
- Written assessment practice tests
- Try to focus on the specific thing the question is asking
- What main conceptual point is the question driving at? Need to emphasize that in your answer
- BoostNote for md for formatting

## Practice Questions

- What is the relationship between classes and objects?
  - Classes define attributes and behaviors for the different objects we instantiate out of the class
  - Classes are the _blueprints_ for the objects
  - Explain further with code about attributes and behaviors
  - Use example of `Animal` class which has attributes `@name` and `@type` with behaviors `#eats`
  - `new` creates an object of the class that calls it and then calls the `initialize` instance method on that object
- Explain inheritance
  - Touch on the _why_ as well as the _how_
  - Difference between _class inheritance_ and _interface inheritance_

What will the following code output and why?

```ruby
class Cat
  attr_reader :name, :color

  def initialize(name)
    @name = name
  end

  def dye_in_blue
    @color = 'blue'
  end
end

kitty = Cat.new('Kitty')
p kitty.color
```

- The above will output `nil` because the instance variable `@color` has never been initialized.
- What's the scope of an instance variable? Accessible on the object level. Make sure you can demonstrate how that works!
- Watch out for little typos, especially in the interview

What will the following code output and why?

```ruby
class Dog
  def initialize(name)
    @name = name
  end
end

puppy = Dog.new('Bengi')
another_puppy = Dog.new('Benji')

p puppy == another_puppy
```

- The code will output false
- The `==` method by default checks to see if the object's being compared are actually the _same_ object in memory.
- This is because this is the default implementation for `==` in `BasicObject`.
- If we want the code to output `true`, we can _override_ the `==` method in the `Dog` class so that it knows which value we want to compare instead of just comparing if the actual object in memory is the same.
