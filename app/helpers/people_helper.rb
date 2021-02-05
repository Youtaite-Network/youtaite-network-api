module PeopleHelper
  def get_person_info misc_id, id_type
    thumbnail = '#'
    if id_type == 'yt'
      url = 'https://youtube.googleapis.com/youtube/v3/channels?id=' + misc_id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
      response = HTTParty.get(url).parsed_response
      display_name = response['items'][0]['snippet']['title']
      thumbnail = response['items'][0]['snippet']['thumbnails']['default']['url']
    elsif id_type == 'tw'
      display_name = "@#{misc_id}"
    else # no_link
      display_name = misc_id[1..-2]
    end

    return {
      name: display_name,
      thumbnail: thumbnail,
    }
  end
end