class OngoingMatchService include Singleton
  def initialize
    @matches = {}
  end

  def add(match_data)
    uuid = SecureRandom.uuid
    @matches[uuid] = match_data
    uuid
  end

  def get(uuid)
    @matches[uuid]
  end
end
