class User
  attr_reader :name

  def initialize name
    @name = name
  end

  def move
    puts 'Your move: '
    move = gets
    Configuration.all[move.to_i]
  end
end