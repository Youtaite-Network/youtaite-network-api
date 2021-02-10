class ApplicationController < ActionController::API
  include CollabsHelper
  include UsersHelper
  include PeopleHelper
  include AuthHelper
  include TwitterApiHelper
  include YoutubeApiHelper
  include ::ActionController::Cookies
  
  def welcome
    msg = {:message => 'welcome', :status => :ok}
    render :json => msg
  end
end
