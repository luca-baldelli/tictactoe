class AI
  attr_reader :name

  def initialize name
    @name = name
  end

  def move
    Configuration.all.sample
  end
end