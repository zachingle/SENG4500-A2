# Zachariah Ingle C3349554 SENG4500
# frozen_string_literal: true

require_relative "board"
require_relative "ship"

# A battleship game board
class Battleship
  SIZE = 10

  def initialize
    @ships = Ship.subclasses.map(&:new)
    @sunk_ships = []
    @board = Board.new(size: SIZE, ships: @ships)
    @other_player_board = Board.new(size: SIZE)
    @won = false
    @lost = false
  end

  def new_message(message)
    event, position = message.split(":")

    case event
    when "GAME OVER"
      @won = true
    when "HIT", "SUNK"
      @other_player_board.hit(position)
    when "MISS"
      @other_player_board.miss(position)
    when "FIRE"
      fire(position)
    end
  end

  def fire(position)
    result = @board.fire(position)

    return "MISS:#{position}" if result == :miss

    sunk_ship = (@ships - @sunk_ships).find(&:sunk?)

    unless sunk_ship.nil?
      @sunk_ships << sunk_ship

      if @ships.size == @sunk_ships.size
        @lost = true
        return "GAME OVER:#{position}:#{sunk_ship.name}"
      end

      return "SUNK:#{position}:#{sunk_ship.name}"
    end

    "HIT:#{position}"
  end

  def to_s
    "Your board\n#{@board}\nOther player's board\n#{@other_player_board}"
  end

  def inside_board?(position)
    @board.inside_board?(position)
  end

  def game_over?
    won? || lost?
  end

  def won?
    @won
  end

  def lost?
    @lost
  end
end
