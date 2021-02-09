module CollabsHelper
  def get_collab_info yt_id
    collab = Collab.find_by(yt_id: yt_id)
    return collab if collab
    url = 'https://youtube.googleapis.com/youtube/v3/videos?id=' + yt_id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return if has_error(response, yt_id)
    return {
      title: response['items'][0]['snippet']['title'],
      thumbnail: response['items'][0]['snippet']['thumbnails']['medium']['url'],
      description: response['items'][0]['snippet']['description'],
      person_id: response['items'][0]['snippet']['channelId'],
    }
  end

  private
    def has_error response, id
      if response['error'] # probably quota exceeded
        Rails.logger.error "Error when getting collab info for: #{id}. #{response['error']}"
        return true
      elsif response['items'].empty? # video is private/inaccessible?
        Rails.logger.error "Error when getting collab info for: #{id}. Collab not found - is it private?"
        return true
      end
      return false
    end
end