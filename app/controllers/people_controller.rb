class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:create, :info, :info_from_url, :info_from_tw_url]

  # GET /people
  def index
    @people = Person.all

    render json: @people
  end

  # GET /people/1
  def show
    render json: @person
  end

  # POST /people
  def create
    @person = Person.new(person_params)
    info = get_person_info(person_params[:misc_id], person_params[:id_type])
    if !info
      render json: 'Error getting person info', status: :unprocessable_entity
      return
    end
    @person.name, @person.thumbnail = info.values_at(:name, :thumbnail)

    if @person.save
      render json: @person, status: :created, location: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # GET /people/info/:yt_id
  def info
    yt_id = params[:yt_id]
    info = get_person_info(yt_id, 'yt')
    if !info
      render json: 'Error getting person info', status: :unprocessable_entity
      return
    end
    render json: info, status: :ok
  end

  # GET /people/info_from_url/:channel_url
  def info_from_url
    channel_url = params[:channel_url]
    if not (channel_url.start_with? 'http')
      channel_url = "https://#{channel_url}"
    end
    channel_path = URI(channel_url).path

    # /channel/id
    if channel_path.include? '/channel/'
      misc_id = channel_path.split('/')[2]
      output = get_yt_person_info_from_id(misc_id)
    # /user/username
    elsif channel_path.include? '/user/'
      username = channel_path.split('/')[2]
      output = get_yt_person_info_from_username(username)
    # /c/search_string or /search_string
    else
      if channel_path.include? '/c/'
        search_string = channel_path.split('/')[2]
      else
        search_string = channel_path.split('/')[1]
      end
      output = get_yt_people_from_query search_string
    end

    if !output
      render json: 'Error getting person info', status: :unprocessable_entity
      return
    end
    render json: output, status: :ok
  end

  def info_from_tw_url
    tw_url = params[:tw_url]
    output = get_tw_person_info_from_url tw_url
    if !output
      render json: 'Error getting person info', status: :unprocessable_entity
      return
    end
    render json: output, status: :ok
  end

  # # PATCH/PUT /people/1
  # def update
  #   if @person.update(person_params)
  #     render json: @person
  #   else
  #     render json: @person.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /people/1
  def destroy
    @person.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def person_params
      params.require(:person).permit(:misc_id, :id_type, :name, :thumbnail)
    end
end
