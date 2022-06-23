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
    yt_id = params["yt_id"]
    # find or create collab
    collab = Collab.find_by(yt_id: yt_id)
    if collab.nil?
      info = get_collab_info yt_id
      # find or create person who uploaded collab
      person_misc_id = info[:channel_id]
      person = Person.find_by(misc_id: person_misc_id)
      if !person
        person_info = get_person_info person_misc_id, "yt"
        person = Person.new({
          misc_id: person_misc_id,
          id_type: "yt",
          name: person_info[:name],
          thumbnail: person_info[:thumbnail]
        })
        if !person.save
          Rails.logger.error person.errors.full_messages
          render json: person.errors.messages, status: :bad_request
        end
      end
      # create collab
      collab = Collab.new({
        yt_id: yt_id,
        title: info[:title],
        thumbnail: info[:thumbnail],
        person_id: person.id,
        published_at: info[:published_at]
      })
      if !collab.save
        Rails.logger.error collab.errors.full_messages
        render json: collab.errors.messages, status: :bad_request
        return
      end
    end
    # find each person
    params["people"].each do |person_obj|
      # try to find using :id
      person = Person.find_by(id: person_obj["id"])
      if person.nil?
        # try to find through misc_id
        person = Person.find_by(misc_id: person_obj["misc_id"])
      end
      if person.nil?
        # create new person
        display_name, misc_id, id_type, thumbnail = person_obj.values_at("name", "misc_id", "id_type", "thumbnail")
        person = Person.new({
          name: display_name,
          misc_id: misc_id,
          id_type: id_type,
          thumbnail: thumbnail
        })
        if !person.save
          Rails.logger.error person.errors.full_messages
          render json: person.errors.messages, status: :bad_request
          return
        end
      end
      # add roles
      (person_obj["roles"] || []).each do |role_name|
        role = Role.new({
          collab_id: collab.id,
          person_id: person.id,
          role: role_name
        })
        if !role.save
          Rails.logger.error role.errors.full_messages
          render json: role.errors.messages, status: :bad_request
          return
        end
      end
    end
    render plain: "Submitted", status: :ok
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
