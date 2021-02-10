module TwitterApiHelper
  def get_tw_person_from_id id
    url = "https://api.twitter.com/1.1/users/show.json?id=#{id}"
    headers = { 'Authorization' => "Bearer #{ENV['TWITTER_BEARER_TOKEN']}" }
    response = HTTParty.get(url, headers: headers).parsed_response
    return if has_error(response, id)
    return {
      misc_id: id.to_s,
      id_type: 'tw',
      name: "#{response['name']} (@#{screen_name})",
      thumbnail: response['profile_image_url_https'],
    }
  end

  def get_tw_person_from_url url
    screen_name = url
    if url.include? 'twitter.com'
      if !url.start_with? 'http'
        url = "https://#{url}"
      end
      screen_name = URI(url).path.split('/')[1]
    end
    url = "https://api.twitter.com/1.1/users/show.json?screen_name=#{screen_name}"
    headers = { 'Authorization' => "Bearer #{ENV['TWITTER_BEARER_TOKEN']}" }
    response = HTTParty.get(url, headers: headers).parsed_response
    return if has_error(response, screen_name)
    return {
      misc_id: response['id_str'],
      id_type: 'tw',
      name: "#{response['name']} (@#{screen_name})",
      thumbnail: response['profile_image_url_https'],
    }
  end

  private
    def has_error response, id
      if response['errors']
        Rails.logger.error "Error when getting TW person info for: #{id}. #{response}"
        return true
      end
      return false
    end
end