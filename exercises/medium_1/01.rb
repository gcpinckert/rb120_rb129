# Modify the given class such that flip_switch and switch= are private
# Add a private getter for `@switch`
# Add a method to `Machine` that shows how to use that getter

class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def show_switch_state
    switch
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end