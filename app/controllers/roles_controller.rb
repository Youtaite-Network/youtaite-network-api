class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy]
  before_action :logged_in_user, only: [:create, :submit]

  # GET /roles
  def index
    @roles = Role.all

    render json: @roles
  end

  # GET /roles/1
  def show
    render json: @role
  end

  # POST /roles
  def create
    @role = Role.new(role_params)

    if @role.save
      render json: @role, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # POST /roles/submit
  def submit
    # find collab
    yt_id = params['yt_id']
    collab = Collab.find_by(yt_id: yt_id)
    if collab.nil? # create new collab
      info = get_collab_info yt_id
      collab = Collab.new({
        yt_id: yt_id,
        title: info[:title],
        thumbnail: info[:thumbnail],
      })
      if !collab.save
        Rails.logger.error collab.errors.full_messages
      end
    end
    # find each person
    params['people'].each do |person_obj|
      if person_obj['id'].nil?
        # create new person
        misc_id = person_obj['misc_id']
        id_type = person_obj['id_type']
        info = get_person_info(misc_id, id_type)
        person = Person.new({
          misc_id: misc_id,
          id_type: id_type,
          name: info[:display_name],
          thumbnail: info[:thumbnail],
        })
        if !person.save
          Rails.logger.error person.errors.full_messages
        end
      else
        person = Person.find(person_obj['id'])
      end
      # add roles
      person_obj['roles'].each do |role_name|
        role = Role.new({
          collab_id: collab.id,
          person_id: person.id,
          user_id: current_user.id,
          role: role_name,
        })
        if !role.save
          Rails.logger.error role.errors.full_messages
        end
      end
    end
    set_headers current_user
    render json: 'Ok', status: :ok
  end

  # # PATCH/PUT /roles/1
  # def update
  #   if @role.update(role_params)
  #     render json: @role
  #   else
  #     render json: @role.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /roles/1
  # def destroy
  #   @role.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:role, :person_id, :collab_id)
    end
end
