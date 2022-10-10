# frozen_string_literal: true

# A battleship game square
class Square
  attr_accessor :hit, :missed, :ship

  def initialize
    @hit = false
    @missed = false
    @ship = nil
  end

  def hit?
    hit
  end

  def missed?
    missed
  end

  def taken?
    !ship.nil?
  end

  def to_s
    return "X" if hit?
    return "." if missed?
    return ship.identifier if taken?

    " "
  end
end
