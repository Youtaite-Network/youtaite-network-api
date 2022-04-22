module TwitterApiHelper
  def get_tw_person_from_id id
    url = "https://api.twitter.com/2/users/#{id}?user.fields=profile_image_url"
    headers = { 'Authorization' => "Bearer #{ENV['TWITTER_BEARER_TOKEN']}" }
    response = HTTParty.get(url, headers: headers).parsed_response
    return if tw_has_error(response, id)
    response_data = response['data']
    return {
      misc_id: id.to_s,
      id_type: 'tw',
      name: "#{response_data['name']} (@#{response_data['username']})",
      thumbnail: response_data['profile_image_url'],
    }
  end

  def get_tw_person_from_url url
    username = url
    if url.include? 'twitter.com'
      if !url.start_with? 'http'
        url = "https://#{url}"
      end
      username = URI(url).path.split('/')[1]
    end
    url = "https://api.twitter.com/2/users/by/username/#{username}?user.fields=profile_image_url"
    headers = { 'Authorization' => "Bearer #{ENV['TWITTER_BEARER_TOKEN']}" }
    response = HTTParty.get(url, headers: headers).parsed_response
    return if tw_has_error(response, username)
    response_data = response['data']
    return {
      misc_id: response_data['id'],
      id_type: 'tw',
      name: "#{response_data['name']} (@#{username})",
      thumbnail: response_data['profile_image_url'],
    }
  end

  # DO NOT USE OUTSIDE OF THIS MODULE
  def tw_has_error response, id
    if response['errors']
      Rails.logger.error "Error when getting TW person info for: #{id}. #{response}"
      return true
    end
    return false
  end
end