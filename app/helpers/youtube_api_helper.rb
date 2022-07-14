# Helper methods for the YouTube Data v3 API.
# Note: Heroku does not provide a static IP address from which requests will be sent.
# The Fixie add-on allows requests to be sent through a provided proxy server, which
# "fixes" the IP address that the request is sent from. This is required for using
# the YouTube API because the API key is restricted by IP address.
# todo: abstract out building the HTTP request
module YoutubeApiHelper
  def get_yt_person_from_id id
    url = "https://youtube.googleapis.com/youtube/v3/channels?id=" + id + "&key=" + ENV["GOOGLE_API_KEY"] + "&part=snippet"
    response = HTTParty.get(url, proxy_options).parsed_response
    return if yt_has_error(response, id) || yt_no_results(response, id)
    display_name = response["items"][0]["snippet"]["title"]
    thumbnail = response["items"][0]["snippet"]["thumbnails"]["default"]["url"]
    {
      misc_id: id,
      id_type: "yt",
      name: display_name,
      thumbnail: thumbnail
    }
  end

  def get_yt_person_from_username username
    url = "https://youtube.googleapis.com/youtube/v3/channels?forUsername=" + username + "&key=" + ENV["GOOGLE_API_KEY"] + "&part=snippet"
    response = HTTParty.get(url, proxy_options).parsed_response
    return if yt_has_error(response, username) || yt_no_results(response, username)
    {
      id_type: "yt",
      misc_id: response["items"][0]["id"],
      name: response["items"][0]["snippet"]["title"],
      thumbnail: response["items"][0]["snippet"]["thumbnails"]["default"]["url"]
    }
  end

  def get_yt_people_from_query query
    url = "https://youtube.googleapis.com/youtube/v3/search?q=" + query + "&key=" + ENV["GOOGLE_API_KEY"] + "&type=channel&part=snippet"
    response = HTTParty.get(url, proxy_options).parsed_response
    return if yt_has_error(response, query)
    response["items"].map do |item|
      {
        id_type: "yt",
        misc_id: item["snippet"]["channelId"],
        name: item["snippet"]["title"],
        thumbnail: item["snippet"]["thumbnails"]["default"]["url"]
      }
    end
  end

  def get_yt_person_from_c_url c_url
    Rails.logger.debug "Beginning web-scraping on #{c_url}"
    begin
      doc = Nokogiri::HTML(URI.parse(c_url).open)
    rescue OpenURI::HTTPError
      return
    end
    scripts = doc.xpath("//script").collect(&:text)
    id = nil
    scripts.each do |script|
      match_data = /"key":"browse_id","value":"[\w\-_]{24}"/.match(script)
      if match_data
        id = /[\w\-_]{24}/.match(match_data[0])[0]
        break
      end
    end
    Rails.logger.debug "id: #{id}"
    return if id.nil?
    get_yt_person_from_id id
  end

  def get_yt_person_from_url url
    channel_path = URI(url).path
    # /channel/id
    if channel_path.include? "/channel/"
      misc_id = channel_path.split("/")[2]
      get_yt_person_from_id(misc_id)
    # /user/username
    elsif channel_path.include? "/user/"
      username = channel_path.split("/")[2]
      get_yt_person_from_username(username)
    # /c/XXX or /XXX
    else
      output = get_yt_person_from_c_url url
      return output if output
      Rails.logger.debug "Web-scraping failed, using search"
      # if web-scraping fails, use search
      cname = if channel_path.include? "/c/"
        channel_path.split("/")[2]
      else
        channel_path.split("/")[1]
      end
      get_yt_people_from_query cname
    end
  end

  # Get information about the video with the given YouTube ID.
  # todo: change return type to Collab
  def get_collab_info yt_id
    url = "https://youtube.googleapis.com/youtube/v3/videos?id=" + yt_id + "&key=" + ENV["GOOGLE_API_KEY"] + "&part=snippet"
    response = HTTParty.get(url, proxy_options).parsed_response
    return if yt_has_error(response, yt_id) || yt_no_results(response, yt_id)
    {
      yt_id: yt_id,
      title: response["items"][0]["snippet"]["title"],
      thumbnail: response["items"][0]["snippet"]["thumbnails"]["medium"]["url"],
      description: response["items"][0]["snippet"]["description"],
      channel_id: response["items"][0]["snippet"]["channelId"],
      published_at: response["items"][0]["snippet"]["publishedAt"]
    }
  end

  # todo: make this private
  def yt_has_error response, id
    if response["error"]
      Rails.logger.error "Error when getting YT info for: #{id}. #{response}"
      return true
    end
    false
  end

  # todo: make this private
  def yt_no_results response, id
    if response["items"].nil? || response["items"].empty?
      Rails.logger.error "Could not find YT items matching: #{id}. Is it private?"
      return true
    end
    false
  end

  # Get the proxy request options hash.
  # todo: make this private
  def proxy_options
    return {} if ENV["FIXIE_URL"].nil?
    fixie = URI.parse ENV["FIXIE_URL"]
    {
      http_proxyaddr: fixie.host,
      http_proxyport: fixie.port,
      http_proxyuser: fixie.user,
      http_proxypass: fixie.password
    }
  end
end
