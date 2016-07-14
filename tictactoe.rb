require_relative './move'
require_relative './configuration'
require_relative './ai'
require_relative './user'

class Game
  attr_reader :winning_player, :players

  def initialize *players
    @moves = [
        Configuration.new([]),
        Configuration.new([])
    ]

    @players = players
    @active_player = 0
  end

  def play
    Configuration.all.each_with_index do |move, i|
      puts "Move #{i}"
      puts move.config.to_a.map { |r| r.inspect }
      puts "\n"
    end

    loop do
      play_turn(@players[@active_player].move)
      break if winning_player
    end

    puts(winning_player == 'none'  ? 'none' : @players[winning_player].name + ' wins')
  end

  def play_turn(move)
    @winning_player = 'none' if no_moves_available?

    if move_available?(move)
      active_player_moves << move
      active_player_wins? ? assign_winner : switch_turn
      puts(to_s)
      puts("\n")
    end
  end

  def switch_turn
    @active_player = @active_player == 0 ? 1 : 0
  end

  def assign_winner
    @winning_player = @active_player
  end

  def active_player_wins?
    active_player_moves.winning?
  end

  def move_available?(move)
    !game_configuration.include?(move)
  end

  def no_moves_available?
    !game_configuration.representation.index { |el| el == 0 }
  end

  def to_s
    Configuration[Move.new(@moves[0].representation), Move.new(@moves[1].representation * 2)].representation.to_a.map { |r| r.inspect }
  end

  def game_configuration
    Configuration[Move.new(@moves.map(&:representation).inject(:+))]
  end

  def active_player_moves
    @moves[@active_player]
  end
end

Game.new(User.new('luca'), AI.new('sara')).play
