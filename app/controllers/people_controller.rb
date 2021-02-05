class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:create]

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
