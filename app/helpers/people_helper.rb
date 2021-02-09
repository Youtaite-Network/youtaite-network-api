module PeopleHelper
  def get_person_info misc_id, id_type
    person = Person.find_by(misc_id: misc_id)
    return person if person
    thumbnail = '#'
    if id_type == 'yt'
      url = 'https://youtube.googleapis.com/youtube/v3/channels?id=' + misc_id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
      response = HTTParty.get(url).parsed_response
      return if has_error(response, misc_id)
      display_name = response['items'][0]['snippet']['title']
      thumbnail = response['items'][0]['snippet']['thumbnails']['default']['url']
    elsif id_type == 'tw'
      display_name = "@#{misc_id}"
    else # no_link
      display_name = misc_id[1..-2]
    end

    return {
      id_type: id_type,
      misc_id: misc_id,
      name: display_name,
      thumbnail: thumbnail,
    }
  end

  def get_person_info_from_username username
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

  def get_people_from_query query
    url = 'https://youtube.googleapis.com/youtube/v3/search?q=' + search_string + '&key=' + ENV['GOOGLE_API_KEY'] + '&type=channel&part=snippet'
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
        Rails.logger.error "Error when getting person info for: #{id}. #{response['error']}"
        return true
      end
      return false
    end
end