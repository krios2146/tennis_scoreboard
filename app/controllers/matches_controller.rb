class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show update new create ]

  def initialize(*args)
    super(*args)
    @ongoing_match_service = OngoingMatchService.instance
  end

  # GET /matches
  def index
    @matches = Match.all
  end

  # GET /matches/:id
  def show
    uuid = params[:id]

    @match = @ongoing_match_service.get(uuid)
  end

  # GET /matches/new
  def new
  end

  # POST /matches
  def create
    match_params = params.fetch(:match).permit(:player_one, :player_two)

    player_one_name = match_params[:player_one]
    player_two_name = match_params[:player_two]

    if player_one_name == player_two_name
      @error = "Players cannot have identical names: #{player_one_name}"
      render :new and return
    end

    player_service = PlayerService.instance

    player_one = player_service.create_or_find_player(player_one_name)
    player_two = player_service.create_or_find_player(player_two_name)

    ongoing_match_service = OngoingMatchService.instance

    uuid = ongoing_match_service.add({ player_one: player_one, player_two: player_two })

    redirect_to match_path(uuid)
  end

  # PATCH/PUT /matches/:id
  def update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.new
    end
end
