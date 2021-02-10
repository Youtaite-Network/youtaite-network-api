module YoutubeApiHelper
  def get_yt_person_info_from_id id
    url = 'https://youtube.googleapis.com/youtube/v3/channels?id=' + id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if has_error(response, id)
    display_name = response['items'][0]['snippet']['title']
    thumbnail = response['items'][0]['snippet']['thumbnails']['default']['url']
    return {
      misc_id: id,
      id_type: 'yt',
      name: display_name,
      thumbnail: thumbnail,
    }
  end

  def get_yt_person_info_from_username username
    url = 'https://youtube.googleapis.com/youtube/v3/channels?forUsername=' + username + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if has_error(response, username)
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
    return if has_error(response, query)
    return response['items'].map do |item| 
      {
        id_type: 'yt',
        misc_id: item['snippet']['channelId'],
        name: item['snippet']['title'],
        thumbnail: item['snippet']['thumbnails']['default']['url'],
      }
    end
  end

  private
    def has_error response, id
      if response['error']
        Rails.logger.error "Error when getting YT person info for: #{id}. #{response}"
        return true
      end
      return false
    end
end