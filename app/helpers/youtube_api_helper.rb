module YoutubeApiHelper
  def get_yt_person_from_id id
    url = 'https://youtube.googleapis.com/youtube/v3/channels?id=' + id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if has_yt_error(response, id)
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
    return if has_yt_error(response, username)
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
    return if has_yt_error(response, query)
    return response['items'].map do |item| 
      {
        id_type: 'yt',
        misc_id: item['snippet']['channelId'],
        name: item['snippet']['title'],
        thumbnail: item['snippet']['thumbnails']['default']['url'],
      }
    end
  end

  def get_yt_person_from_url url
    channel_path = URI(url).path
    # /channel/id
    if channel_path.include? '/channel/'
      misc_id = channel_path.split('/')[2]
      output = get_yt_person_from_id(misc_id)
    # /user/username
    elsif channel_path.include? '/user/'
      username = channel_path.split('/')[2]
      output = get_yt_person_from_username(username)
    # /c/search_string or /search_string
    else
      if channel_path.include? '/c/'
        search_string = channel_path.split('/')[2]
      else
        search_string = channel_path.split('/')[1]
      end
      output = get_yt_people_from_query search_string
    end
    output
  end

  def get_collab_info yt_id
    url = 'https://youtube.googleapis.com/youtube/v3/videos?id=' + yt_id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if has_yt_error(response, yt_id)
    return {
      yt_id: yt_id,
      title: response['items'][0]['snippet']['title'],
      thumbnail: response['items'][0]['snippet']['thumbnails']['medium']['url'],
      description: response['items'][0]['snippet']['description'],
      channel_id: response['items'][0]['snippet']['channelId'],
    }
  end

  def has_yt_error response, id
    if response['error']
      Rails.logger.error "Error when getting YT info for: #{id}. #{response}"
      return true
    elsif response['items'].empty? # video is private/inaccessible?
      Rails.logger.error "Could not find YT items matching: #{id}. Is it private?"
      return true
    end
    return false
  end
end