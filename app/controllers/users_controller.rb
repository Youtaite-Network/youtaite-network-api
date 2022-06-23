class UsersController < ApplicationController
  before_action :validate_id_token, only: [:signin]

  def signin
    user = User.find_by(alt_user_id: session[:alt_user_id])
    if user.nil?
      user = User.create({
        alt_user_id: session[:alt_user_id],
        id_type: :google
      })
    end
    set_headers user
    render plain: "Signed in with Google", status: :ok
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:idtoken)
  end

  def validate_id_token
    validator = GoogleIDToken::Validator.new
    begin
      payload = validator.check(params[:idtoken], ENV["GOOGLE_CLIENT_ID"])
      alt_user_id = payload["sub"]
      session[:alt_user_id] = alt_user_id
      true
    rescue GoogleIDToken::ValidationError => e
      puts "Cannot validate: #{e}"
      render json: {message: "Bad Request", reason: "Error validating Google token ID"}, status: :bad_request
    end
  end
end
