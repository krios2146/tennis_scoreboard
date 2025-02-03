class MatchesController < ApplicationController
  def initialize(*args)
    super(*args)
    @ongoing_match_service = OngoingMatchService.instance
    @player_service = PlayerService.instance
    @score_service = ScoreService.instance
  end

  # GET /matches
  def index
    @matches = Match.all
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

    Rails.logger.info "#{@match.inspect}"

    render :show
  end
end
