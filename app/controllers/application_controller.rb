class ApplicationController < ActionController::API
  def welcome
    msg = {:message => 'welcome', :status => :ok}
    render :json => msg
  end
end
