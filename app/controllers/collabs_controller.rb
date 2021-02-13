class CollabsController < ApplicationController
  before_action :set_collab, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:info, :create, :new_random, :destroy]

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

  # # GET /collabs/1
  # def show
  #   render json: @collab
  # end

  # GET /collabs/info/:yt_id
  def info
    yt_id = params[:yt_id]
    info = get_collab_info(yt_id)
    if !info
      render json: 'Could not find collab info', status: :not_found
      return
    end
    render json: info, status: :ok
  end

  # # POST /collabs
  # def create
  #   @collab = Collab.new(collab_params)
  #   info = get_collab_info(collab_params[:yt_id])
  #   if !info
  #     render json: 'Error getting collab info', status: :unprocessable_entity
  #     return
  #   end
  #   @collab.title, @collab.thumbnail = info.values_at(:title, :thumbnail)
  #   if @collab.save
  #     render json: @collab, status: :created, location: @collab
  #   else
  #     render json: @collab.errors, status: :unprocessable_entity
  #   end
  # end

  # GET /collabs/new_random
  def new_random
    collab = Collab.where.not(id: Role.pluck(:collab_id)).order('RANDOM()').first
    if !collab
      render json: 'No not-yet-analyzed collabs were found', status: :bad_request
    else
      info = get_collab_info(collab.yt_id)
      if !info
        render json: 'Error getting collab info', status: :unprocessable_entity
      else
        render json: info, status: :ok
      end
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

  # DELETE /collabs/1
  def destroy
    if @collab
      if @collab.destroy
        render json: 'Destroyed', status: :ok
      else
        render json: 'Not destroyed; attempt logged for further review', status: :bad_request
      end
    else
      render json: 'Collab not found', status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collab
      @collab = Collab.find_by(yt_id: params[:yt_id])
    end

    # Only allow a trusted parameter "white list" through.
    def collab_params
      Rails.logger.debug params
      params.require(:collab).permit(:yt_id)
    end
end
