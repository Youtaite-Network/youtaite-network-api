module UrlHelper
  def follow_redirects url, max_redirects = 10
    stop_count = 0
    prev_url = ""
    while !url.nil? and stop_count < max_redirects
      res = Net::HTTP.get_response(URI(url))
      prev_url = url
      url = res["location"]
      stop_count += 1
    end
    prev_url
  end
end
