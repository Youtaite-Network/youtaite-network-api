class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:create, :info, :info_from_url, :info_from_tw_url]

  # GET /people
  def index
    index_params = params.permit(:id, :misc_id, :id_type, :name, :fields)
    where_params = index_params.slice(:id, :misc_id, :id_type, :name)
      .transform_values { |value| value.split(",") }
    people = Person.where(where_params)

    # Set `fields` to the intersection of the given field names and the available columns
    fields = index_params[:fields]&.split(",") & Person.column_names
    fields ||= [:id, :misc_id, :id_type, :name, :thumbnail] # Default value

    if fields.any?
      people = people.pluck(*fields).map do |field_values|
        # `pluck` returns an array of arrays, so turn it into an array of hashes
        fields.zip([*field_values]).to_h
      end
    end

    render json: people
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
      render plain: "Error getting person info", status: :unprocessable_entity
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
    info = get_person_info(yt_id, "yt")
    if !info
      render plain: "Could not find person info", status: :not_found
      return
    end
    render json: info, status: :ok
  end

  # GET /people/info_from_url/:url
  def info_from_url
    url = params[:url]
    if !(url.start_with? "http")
      url = "https://#{url}"
    end
    url = follow_redirects url

    host = URI(url).host.split(".")[-2]

    if host == "youtube"
      output = get_yt_person_from_url url
    elsif host == "twitter"
      output = get_tw_person_from_url url
    else
      render plain: "Host not recognized", status: :bad_request
      return
    end

    if !output
      render plain: "Could not find person info", status: :not_found
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
