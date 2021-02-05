class ApplicationController < ActionController::API
  include CollabsHelper
  include UsersHelper
  include PeopleHelper
  include AuthHelper
  include ::ActionController::Cookies
  
  def welcome
    msg = {:message => 'welcome', :status => :ok}
    render :json => msg
  end
end
