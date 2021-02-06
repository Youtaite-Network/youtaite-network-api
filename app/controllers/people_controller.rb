class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:create, :info, :get_id]

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
    @person.name, @person.thumbnail = get_person_info(person_params[:misc_id], person_params[:id_type]).values_at(:name, :thumbnail)

    if @person.save
      render json: @person, status: :created, location: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  # GET /people/info/:yt_id
  def info
    yt_id = params[:yt_id]
    display_name, thumbnail = get_person_info(yt_id, 'yt').valuesAt(:name, :thumbnail)
    render json: {
      name: display_name,
      thumbnail: thumbnail,
    }, status: :ok
  end

  # GET /people/get_id/:channel_url
  def get_id
    channel_path = URI(params[:channel_url]).path

    # /channel/id
    if channel_path.include? '/channel/'
      yt_id = channel_path.split('/')[1]
      display_name, thumbnail = get_person_info(yt_id, 'yt').valuesAt(:name, :thumbnail)
      output = [{
        yt_id: yt_id,
        name: display_name,
        thumbnail: thumbnail,
      }]
    # /user/username
    elsif channel_path.include? '/user/'
      username = channel_path.split('/')[1]
      url = 'https://youtube.googleapis.com/youtube/v3/channels?forUsername=' + username + '&key=' + ENV['GOOGLE_API_KEY'] + '&type=channel&part=snippet'
      response = HTTParty.get(url).parsed_response
      output = [{
        yt_id: response['items'][0]['id'],
        name: response['items'][0]['snippet']['title'],
        thumbnail: response['items'][0]['snippet']['thumbnails']['default']['url'],
      }]
    # /c/search_string or /search_string
    else
      if channel_path.include? '/c/'
        search_string = channel_path.path.split('/')[1]
      else
        search_string = channel_path.path.split('/')[0]
      end
      url = 'https://youtube.googleapis.com/youtube/v3/search?q=' + search_string + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
      response = HTTParty.get(url).parsed_response
      output = response['items'].map do |item| 
        {
          yt_id: item['snippet']['channelId'],
          name: item['snippet']['title'],
          thumbnail: item['snippet']['thumbnails']['default']['url'],
        }
      end
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
      params.require(:person).permit(:misc_id, :id_type)
    end
end
