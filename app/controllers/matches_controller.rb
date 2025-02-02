class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]

  # GET /matches
  def index
    @matches = Match.all
  end

  # GET /matches/:id
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # POST /matches
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: "Match was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/:id
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: "Match was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def match_params
      params.fetch(:match, {})
    end
end
