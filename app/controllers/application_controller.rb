class ApplicationController < ActionController::API
  include UsersHelper
  include PeopleHelper
  include AuthHelper
  include TwitterApiHelper
  include YoutubeApiHelper
  include UrlHelper
  include AuditsHelper
  include ::ActionController::Cookies
  
  def welcome
    render plain: 'welcome', status: :ok
  end
end
