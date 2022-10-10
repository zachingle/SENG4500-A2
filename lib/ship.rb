# Zachariah Ingle C3349554 SENG4500
# frozen_string_literal: true

# A battleship game ship
class Ship
  class AircraftCarrier < Ship
    LENGTH = 5
    IDENTIFER = "A"
  end

  class Battleship < Ship
    LENGTH = 4
    IDENTIFER = "B"
  end

  class Cruiser < Ship
    LENGTH = 3
    IDENTIFER = "C"
  end

  class PatrolBoat < Ship
    LENGTH = 2
    IDENTIFER = "P"
  end

  class Submarine < Ship
    LENGTH = 3
    IDENTIFER = "S"
  end

  attr_accessor :squares
  attr_reader :length, :identifier

  def initialize
    @squares = nil
    @length = self.class::LENGTH
    @identifier = self.class::IDENTIFER
  end

  def sunk?
    @squares.all?(&:hit?)
  end

  def name
    self.class.name.split("::")[1]
  end
end
