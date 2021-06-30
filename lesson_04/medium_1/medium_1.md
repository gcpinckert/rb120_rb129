# Practice Problems: Medium 1

## Question 1

```ruby
class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end
```

We do not need an `@` in front of the `balance` in the method `positive_balance`. This is because `balance`, in this case, does not represent the instance variable `@balance` but rather a method call. The method we are invoking is the getter method defined by the expression `attr_reader :balance` in line 2. `balance` in this case will return the value referenced by `@balance`, which we can then compare against `0` in the `positive_balance?` implementation.

## Question 2

```ruby
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end
```

The method `update_quantity` will result in a `NameError` when called. This is because no setter method for the instance variable `@quantity` has been defined, though we attempt to invoke it on line 11. We can fix this by referencing the `@quantity` instance variable directly on line 11, and thus turn the setter method call into a reassignment statement. But it is perhaps more useful to define a setter method by changing the expression on line 2 to `attr_accessor :quantity, :product_name`. Doing so means we would have to change the call to `quantity=` on line 10 to `self.quantity = ...`.

## Question 3

Regarding the fix above, changing the expression on line 2 to `attr_accessor :quantity, :product_name` may give pubic access to a setter method for `@product_name` that we do not want. Instead, it would be safer to leave only an `attr_reader` for `@product_name`.

Further, we are also allowing public access for the `quantity=` setter method as well. It would be better to make this only available to the class itself, and define a private setter method for `@quantity`.

```ruby
class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    self.quantity = updated_count if updated_count >= 0
  end

  private
  attr_writer :quantity
end
```

## Question 4

See code for [Medium 1: Question 4](./04.rb)

## Question 5

See code for [Medium 1: Question 5](./05.rb)

## Question 6

```ruby
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end
```

Above, we access the instance variable `@template` directly in order to initialize and assign it on line 5. Then, on line 9, we access the value it references using the `template` getter method defined by the expression `attr_accessor :template` on line 2. We do not have to use the `self` keyword here, but we can if we want to show that we are explicitly calling the getter method.

```ruby
class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end
```

Above, we use the setter method defined by the expression `attr_accessor :template` on line 2 to initialize and assign the instance variable `@template` on line 5. Further, on line 9, we use the getter method `template` also defined in the `attr_accessor` expression. We use the `self` keyword here to explicitly show that we are calling the getter method, though this is not necessary for the code to run.

Both code examples have the same results when executed.

## Question 7