require 'matrix'

class Configuration
  extend Enumerable
  attr_accessor :moves, :representation

  NULL_MOVE = Matrix[[0, 0, 0],
                     [0, 0, 0],
                     [0, 0, 0]]

  BASE_MOVES = [
      Matrix[[1, 0, 0],
             [0, 0, 0],
             [0, 0, 0]],
      Matrix[[0, 1, 0],
             [0, 0, 0],
             [0, 0, 0]],
      Matrix[[0, 0, 0],
             [0, 1, 0],
             [0, 0, 0]]
  ]

  BASE_WINNING_CONFIGURATIONS = [
      Matrix[[1, 1, 1],
             [0, 0, 0],
             [0, 0, 0]],
      Matrix[[0, 0, 0],
             [1, 1, 1],
             [0, 0, 0]],
      Matrix[[1, 0, 0],
             [0, 1, 0],
             [0, 0, 1]],
  ]

  class << self
    def all
      @all ||= BASE_MOVES.map do |configuration|
        move = Move.new(configuration)
        [move, move.rotate, move.rotate.rotate, move.rotate.rotate.rotate]
      end.flatten.uniq
    end

    def winning
      @winning ||= BASE_WINNING_CONFIGURATIONS.map do |configuration|
        move = Move.new(configuration)
        [move, move.rotate, move.rotate.rotate, move.rotate.rotate.rotate]
      end.flatten.uniq.map { |c| Configuration[c] }
    end

    def [] *moves
      new(moves)
    end
  end

  def initialize moves
    self.moves = moves
  end

  def << move
    self.moves << move
  end

  def representation
    (self.moves.inject(:+) || Move.new(NULL_MOVE)).config
  end

  def == other
    self.representation == other.representation
  end

  def hash
    self.representation.hash
  end

  def include?(move)
    include = true
    move.config.each_with_index do |el, i, j|
      if el == 1
        include = self.representation[i, j] == el
        break unless include
      end
    end

    include
  end

  def winning?
    self.class.winning.any? { |winning_configuration| self.include? Move.new(winning_configuration.representation) }
  end

  def each &block
    moves.each &block
  end
end

