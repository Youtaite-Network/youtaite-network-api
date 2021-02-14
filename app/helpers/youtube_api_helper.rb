module YoutubeApiHelper
  def get_yt_person_from_id id
    url = 'https://youtube.googleapis.com/youtube/v3/channels?id=' + id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if (yt_has_error(response, id) || yt_no_results(response, id))
    display_name = response['items'][0]['snippet']['title']
    thumbnail = response['items'][0]['snippet']['thumbnails']['default']['url']
    return {
      misc_id: id,
      id_type: 'yt',
      name: display_name,
      thumbnail: thumbnail,
    }
  end

  def get_yt_person_from_username username
    url = 'https://youtube.googleapis.com/youtube/v3/channels?forUsername=' + username + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if (yt_has_error(response, username) || yt_no_results(response, username))
    return {
      id_type: 'yt',
      misc_id: response['items'][0]['id'],
      name: response['items'][0]['snippet']['title'],
      thumbnail: response['items'][0]['snippet']['thumbnails']['default']['url'],
    }
  end

  def get_yt_people_from_query query
    url = 'https://youtube.googleapis.com/youtube/v3/search?q=' + query + '&key=' + ENV['GOOGLE_API_KEY'] + '&type=channel&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if yt_has_error(response, query)
    return response['items'].map do |item| 
      {
        id_type: 'yt',
        misc_id: item['snippet']['channelId'],
        name: item['snippet']['title'],
        thumbnail: item['snippet']['thumbnails']['default']['url'],
      }
    end
  end

  def get_yt_person_from_c_url c_url
    Rails.logger.debug "Beginning web-scraping on #{c_url}"
    begin
      doc = Nokogiri::HTML(URI.open(c_url))
    rescue OpenURI::HTTPError
      return
    end
    scripts = doc.xpath('//script').collect(&:text)
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
    return get_yt_person_from_id id
  end

  def get_yt_person_from_url url
    channel_path = URI(url).path
    # /channel/id
    if channel_path.include? '/channel/'
      misc_id = channel_path.split('/')[2]
      return get_yt_person_from_id(misc_id)
    # /user/username
    elsif channel_path.include? '/user/'
      username = channel_path.split('/')[2]
      return get_yt_person_from_username(username)
    # /c/XXX or /XXX
    else
      output = get_yt_person_from_c_url url
      return output if output
      Rails.logger.debug "Web-scraping failed, using search"
      # if web-scraping fails, use search
      if channel_path.include? '/c/'
        cname = channel_path.split('/')[2]
      else
        cname = channel_path.split('/')[1]
      end
      return get_yt_people_from_query cname
    end
  end

  def get_collab_info yt_id
    url = 'https://youtube.googleapis.com/youtube/v3/videos?id=' + yt_id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if (yt_has_error(response, yt_id) || yt_no_results(response, yt_id))
    return {
      yt_id: yt_id,
      title: response['items'][0]['snippet']['title'],
      thumbnail: response['items'][0]['snippet']['thumbnails']['medium']['url'],
      description: response['items'][0]['snippet']['description'],
      channel_id: response['items'][0]['snippet']['channelId'],
    }
  end

  # DO NOT USE OUTSIDE OF THIS MODULE
  def yt_has_error response, id
    if response['error']
      Rails.logger.error "Error when getting YT info for: #{id}. #{response}"
      return true
    end
    return false
  end

  # DO NOT USE OUTSIDE OF THIS MODULE
  def yt_no_results response, id
    if response['items'].empty?
      Rails.logger.error "Could not find YT items matching: #{id}. Is it private?"
      return true
    end
    return false
  end
end