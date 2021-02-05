class UsersController < ApplicationController
  before_action :validate_id_token, only: [:signin]

  def signin
    user = User.find_by(google_id: session[:google_id])
    if user.nil?
      user = User.create({
        google_id: session[:google_id]
      })
    end
    set_headers user
    render json: 'Signed in with Google', status: :ok
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:idtoken)
    end

    def validate_id_token
      validator = GoogleIDToken::Validator.new
      begin
        payload = validator.check(params[:idtoken], ENV['GOOGLE_CLIENT_ID'])
        google_id = payload['sub']
        session[:google_id] = google_id
        return true
      rescue GoogleIDToken::ValidationError => e
        puts "Cannot validate: #{e}"
        render json: {message: 'Bad Request', reason: 'Error validating Google token ID'}, status: :bad_request
      end
    end
end
