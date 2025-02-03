class OngoingMatchDto
  attr_reader :player_one, :player_two
  attr_accessor :winner_id

  def initialize(player_one, player_two)
    @player_one = player_one
    @player_two = player_two
    @winner_id = nil
  end
end
