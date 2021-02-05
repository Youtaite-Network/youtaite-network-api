class CollabsController < ApplicationController
  before_action :set_collab, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:info, :create]

  # GET /collabs
  def index
    @collabs = Collab.all
    render json: @collabs
  end

  # GET /edges
  def edges
    edges = Collab.edges
    render json: edges.map{|elt| {source: elt[0], target: elt[1]}}
  end

  # GET /collabs/1
  def show
    render json: @collab
  end

  # GET /collabs/info/:yt_id
  def info
    yt_id = collab_params[:yt_id]
    title, description = get_collab_info(yt_id).values_at(:title, :description)
    render json: {
      title: title,
      description: description
    }
  end

  # POST /collabs
  def create
    @collab = Collab.new(collab_params)
    @collab.title, @collab.thumbnail = get_collab_info(collab_params[:yt_id]).values_at(:title, :thumbnail)
    if @collab.save
      render json: @collab, status: :created, location: @collab
    else
      render json: @collab.errors, status: :unprocessable_entity
    end
  end

  # # PATCH/PUT /collabs/1
  # def update
  #   if @collab.update(collab_params)
  #     render json: @collab
  #   else
  #     render json: @collab.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /collabs/1
  # def destroy
  #   @collab.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collab
      @collab = Collab.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def collab_params
      Rails.logger.info params
      params.require(:collab).permit(:yt_id)
    end
end
