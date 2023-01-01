module UrlHelper
  def follow_redirects url
    last_uri = HTTParty.head(url).request.last_uri.to_s
    last_uri || url
  rescue HTTParty::RedirectionTooDeep => error
    Rails.logger.error "Failed to follow redirects for #{url}: #{error}"
    url
  end
end
