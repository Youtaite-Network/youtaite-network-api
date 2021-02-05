module AuthHelper

  def logged_in_user
    unless logged_in?
      render json: {message: 'Not logged in'}, status: :forbidden
    end
  end

  def set_headers user
    token = issue_token user
    response.set_header('Access-Token', token[:token])
    response.set_header('Access-Token-Expiry', token[:expiry])
  end

  private

    def jwt_key
      ENV['SESSION_SECRET']
    end

    def decoded_token
      begin
        token = JWT.decode(request.headers['Authorization'][7..], jwt_key, true, { :algorithm => 'HS256' })
        if DateTime.parse(token[0]['expiry']).past?
          Rails.logger.error "Could not log in user #{token[0]['google_id']}: Token expired (#{token[0]['expiry']})"
          return [{}]
        else
          token
        end
      rescue JWT::DecodeError
        Rails.logger.error "Could not log in user #{token[0]['google_id']}: Token is invalid"
        return [{}]
      end
    end

    def issue_token(user)
      expiry = 2.hours.from_now
      return {
        token: JWT.encode({google_id: user.google_id, expiry: expiry}, jwt_key, 'HS256'),
        expiry: expiry,
      }
    end

    def current_user
      google_id = session[:google_id]
      if google_id.nil?
        google_id = decoded_token[0]['google_id']
      end
      return User.find_by(google_id: google_id)
    end

    def logged_in?
      !current_user.nil?
    end

end