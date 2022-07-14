module AuthHelper
  def logged_in_user
    if logged_in?
      set_headers current_user
    else
      render json: {message: "Not logged in"}, status: :forbidden
    end
  end

  def set_headers user
    token = issue_token user
    response.set_header("Access-Token", token[:token])
    response.set_header("Access-Token-Expiry", token[:expiry])
  end

  private

  def jwt_key
    ENV["SESSION_SECRET"]
  end

  def decoded_token
    token = JWT.decode(request.headers["Authorization"][7..], jwt_key, true, {algorithm: "HS256"})
    if DateTime.parse(token[0]["expiry"]).past?
      Rails.logger.error "Could not log in user #{token[0]["alt_user_id"]}: Token expired (#{token[0]["expiry"]})"
      [{}]
    else
      token
    end
  rescue JWT::DecodeError => error
    Rails.logger.error "Error decoding JWT token #{token}: #{error}"
    [{}]
  end

  def issue_token(user)
    expiry = 2.hours.from_now
    {
      token: JWT.encode({alt_user_id: user.alt_user_id, expiry: expiry}, jwt_key, "HS256"),
      expiry: expiry
    }
  end

  def current_user
    alt_user_id = session[:alt_user_id]
    if alt_user_id.nil?
      alt_user_id = decoded_token[0]["alt_user_id"]
    end
    User.find_by(alt_user_id: alt_user_id)
  end

  def logged_in?
    !current_user.nil?
  end
end
