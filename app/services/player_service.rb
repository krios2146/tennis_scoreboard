class PlayerService include Singleton
  def create_or_find_player(name)
    player = Player.find_by(name: name)
    player ||= Player.create!(name: name)
    player
  end
end
