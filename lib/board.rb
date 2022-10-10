# frozen_string_literal: true

require_relative "ship"
require_relative "square"
require "pry"

# A battleship game board
class Board
  A_ASCII_VALUE = "A".ord

  def initialize(size:, ships: [])
    @size = size
    @grid = Array.new(@size) { Array.new(@size) { Square.new } }

    @ships = ships
    @ships.each { |ship| place_ship(ship) }
  end

  def fire(position)
    raise "#fire can only be used on a board with ships" if other_player_board?

    x, y = decode_position(position)
    square = @grid[x][y]

    if square.taken?
      square.hit = true
      return :hit
    end

    square.missed = true
    :miss
  end

  def hit(position)
    raise "#hit can only be used with a board with no ships" unless other_player_board?

    x, y = decode_position(position)
    square = @grid[x][y]

    square.hit = true
  end

  def miss(position)
    raise "#miss can only be used with a board with no ships" unless other_player_board?

    x, y = decode_position(position)
    square = @grid[x][y]

    square.missed = true
  end

  def inside_board?(position)
    x, y = decode_position(position)

    grid_range = (0...@size)

    return true if grid_range.cover?(x) && grid_range.cover?(y)

    false
  end

  def to_s
    @grid.map do |row|
      ("|---" * 10) + "\n" + row.map { "| #{_1} " }.join + "\n"
    end.join
  end

  private

  def other_player_board?
    @ships.empty?
  end

  def place_ship(ship)
    while ship.squares.nil?
      column = rand(@size)
      row = rand(@size)
      orientation = rand > 0.5 ? :horizontal : :vertical

      if orientation == :horizontal
        next if column + ship.length >= @size

        squares_for_ship = ship.length.times.map do |i|
          @grid[column + i][row]
        end
      else
        next if row + ship.length >= @size

        squares_for_ship = ship.length.times.map do |i|
          @grid[column][row + i]
        end
      end

      next if squares_for_ship.any?(&:taken?)

      squares_for_ship.each { _1.ship = ship }
      ship.squares = squares_for_ship
    end
  end

  # A1 = (0, 0), J10 = (9, 9)
  def decode_position(position)
    row = position.chars[0]
    column = position.chars[1..].join

    x = row.ord - A_ASCII_VALUE
    y = Integer(column, 10) - 1

    [x, y]
  end
end
