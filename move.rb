require 'matrix'

class Move
  attr_accessor :config

  def self.[] *config
    new(Matrix[*config])
  end

  def initialize config
    self.config = config
  end

  def rotate
    self.class.new(self.config.transpose * Matrix[[0, 0, 1],
                                                  [0, 1, 0],
                                                  [1, 0, 0]])
  end

  def eql?(other)
    self.config.eql?(other.config)
  end

  def hash
    self.config.hash
  end

  def to_s
    self.config.to_a.map(&:inspect).join("\n") + "\n\n"
  end

  def + other
    self.class.new(self.config + other.config)
  end
end