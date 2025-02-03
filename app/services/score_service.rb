class ScoreService include Singleton
  def update_score(match, scoring_player_id)
    scoring_player, opponent =
      if match.player_one.id == scoring_player_id
        [ match.player_one, match.player_two ]
      else
        [ match.player_two, match.player_one ]
      end

    if scoring_player.points == 0
      scoring_player.points = 15
      return match
    end

    if scoring_player.points == 15
      scoring_player.points = 30
      return match
    end

    if scoring_player.points == 30
      scoring_player.points = 40
      return match
    end

    if scoring_player.points == 40 and opponent.points == 40
      scoring_player.points = "AD"
      return match
    end

    if opponent.points == "AD"
      opponent.points = 40
      return match
    end

    if scoring_player.points == "AD" or scoring_player.points == 40
      scoring_player.games += 1

      scoring_player.points = 0
      opponent.points = 0
    end

    if scoring_player.games == 7 or (scoring_player.games == 6 and opponent.games <= 4)
      scoring_player.sets += 1

      scoring_player.games = 0
      opponent.games = 0
    end

    if scoring_player.sets == 2
      match.winner = scoring_player_id
    end

    match
  end
end
