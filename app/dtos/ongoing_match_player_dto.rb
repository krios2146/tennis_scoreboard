class OngoingMatchPlayerDto
  attr_accessor :sets, :games, :points, :name, :id

  def initialize(player)
    @id = player.id
    @name = player.name
    @sets = 0
    @games = 0
    @points = 0
  end
end
