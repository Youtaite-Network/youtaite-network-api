module CollabsHelper
  def get_collab_info yt_id
    url = 'https://youtube.googleapis.com/youtube/v3/videos?id=' + yt_id + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    return {
      title: response['items'][0]['snippet']['title'],
      thumbnail: response['items'][0]['snippet']['thumbnails']['medium']['url'],
      description: response['items'][0]['snippet']['description']
    }
  end
end