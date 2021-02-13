class ApplicationController < ActionController::API
  include UsersHelper
  include PeopleHelper
  include AuthHelper
  include TwitterApiHelper
  include YoutubeApiHelper
  include UrlHelper
  include ::ActionController::Cookies
  
  def welcome
    render json: 'welcome', status: :ok
  end
end
