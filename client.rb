# Zachariah Ingle C3349554 SENG4500
# frozen_string_literal: true

require "rbconfig"
require "socket"
require "timeout"
require_relative "lib/battleship"

# A Battleship game client
class Client
  BROADCAST_ADDRESS = "255.255.255.255"

  def initialize(address:, port:)
    @battleship_game = Battleship.new

    @broadcast_socket = UDPSocket.new

    # Allow us to use the same address and port
    option = on_windows? ? Socket::SOREUSEADDR : Socket::SO_REUSEPORT
    @broadcast_socket.setsockopt(Socket::SOL_SOCKET, option, 1)
    @broadcast_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
    @broadcast_socket.bind(address, Integer(port, 10))

    random_port = rand(5000..6000)
    @server = TCPServer.new(random_port)

    my_turn = false

    # Broadcast loop
    puts "Listening for 'NEW PLAYER' message"
    loop do
      msg = Timeout.timeout(29) do
        @broadcast_socket.recvfrom(32)
      end

      sender_port = Integer(msg[0].split(":")[1], 10)
      next if sender_port == random_port # Ignore our own message

      puts "Found new player!"

      sender_address = msg[1][3]
      @other_player = TCPSocket.new(sender_address, sender_port)
      my_turn = false # Player 2

      break
    rescue Timeout::Error
      puts "Sending out 'NEW PLAYER' broadcast message"
      @broadcast_socket.send("NEW PLAYER:#{random_port}", 0, BROADCAST_ADDRESS, port)

      # Probably better of doing this. Wait a second so we don't have to wait till next loop to accept connection
      sleep(1)

      @other_player = @server.accept_nonblock(exception: false)

      if @other_player != :wait_readable
        my_turn = true # Player 1
        break
      end

      puts "Listening for 'NEW PLAYER' message"
    end

    @broadcast_socket.close

    # Main game loop
    loop do
      if my_turn
        my_turn = false

        while true
          print "Your move: "
          position = $stdin.gets.chomp.upcase

          break if @battleship_game.inside_board?(position)

          puts "#{position} is not inside the board."
        end

        @other_player.puts("FIRE:#{position}")

        message = @other_player.gets.chomp
        puts "Received: #{message.dump}"
        @battleship_game.new_message(message)
      else
        my_turn = true

        puts "Waiting for other player's move..."
        message = @other_player.gets.chomp

        puts "The other player sent: #{message.dump}"
        @other_player.puts(@battleship_game.new_message(message))
      end
      puts @battleship_game

      break if @battleship_game.game_over?
    end

    @other_player.close

    puts "You won!" if @battleship_game.won?
    puts "You lost!" if @battleship_game.lost?
  end

  private

  def on_windows?
    os = RbConfig::CONFIG["host_os"]

    os =~ /mingw32/ || os =~ /windows/
  end
end

Client.new(address: ARGV[0], port: ARGV[1])
