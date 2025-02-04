class MatchesController < ApplicationController
  def initialize(*args)
    super(*args)
    @ongoing_match_service = OngoingMatchService.instance
    @player_service = PlayerService.instance
    @score_service = ScoreService.instance
    @page_limit = 5
  end

  # GET /matches
  def index
    query = params[:q]
    @page = params[:page].to_i

    if @page < 0
      @page = 0
    elsif @page > 0
      @page -= 1
    end

    if query == nil
      @matches = Match.limit(@page_limit)
                .offset(@page * @page_limit)
    else
      @matches = Match.joins(:winner, :loser)
                .where("LOWER(players.name) LIKE LOWER(?)", "%#{query}%")
                .limit(@page_limit)
                .offset(@page * @page_limit)
    end
  end

  # GET /matches/:id
  def show
    uuid = params[:id]

    if @match == nil
      @match = @ongoing_match_service.get(uuid)
    end
  end

  # GET /matches/new
  def new
  end

  # POST /matches
  def create
    player_one_name = params[:player_one]
    player_two_name = params[:player_two]

    if player_one_name == player_two_name
      @error = "Players cannot have identical names: #{player_one_name}"
      render :new and return
    end

    if player_one_name.downcase.include?("gay") or player_two_name.downcase.include?("gay")
      redirect_to "https://www.pornhub.com/gayporn", allow_other_host: true  and return
    end

    player_one = @player_service.create_or_find_player(player_one_name)
    player_two = @player_service.create_or_find_player(player_two_name)

    player_one_dto = OngoingMatchPlayerDto.new(player_one)
    player_two_dto = OngoingMatchPlayerDto.new(player_two)

    match = OngoingMatchDto.new(player_one_dto, player_two_dto)

    uuid = @ongoing_match_service.add(match)

    redirect_to match_path(uuid)
  end

  # PATCH/PUT /matches/:id
  def update
    uuid = params[:id]
    scoring_player_id = params[:scoring_player_id].to_i

    @match = @ongoing_match_service.get(uuid)

    @match = @score_service.update_score(@match, scoring_player_id)

    if @match.winner_id == nil
      render :show and return
    end

    if @match.player_one.id == @match.winner_id
      Match.create(winner: Player.find(@match.player_one.id), loser: Player.find(@match.player_two.id))
    else
      Match.create(winner: Player.find(@match.player_one.id), loser: Player.find(@match.player_two.id))
    end

    redirect_to matches_path
  end
end
