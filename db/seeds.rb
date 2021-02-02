collabs = CSV.new(File.open('db/collabs.csv'))
collabs.each do |row|
  url = 'https://youtube.googleapis.com/youtube/v3/videos?id=' + row[0] + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
  response = HTTParty.get(url).parsed_response
  Collab.create({
    yt_id: row[0],
    title: response['items'][0]['snippet']['title'],
    thumbnail: response['items'][0]['snippet']['thumbnails']['medium']['url']
  })
end

people = CSV.new(File.open('db/people.csv'))
people.each do |row|
  Person.create(yt_link: row[0])
end

roles = CSV.new(File.open('db/roles.csv'))
roles.each do |row|
  collab_id = Collab.find_by(yt_id: row[0]).id
  person_id = Person.find_by(yt_link: row[1]).id
  role = row[2]
  Role.create({
    collab_id: collab_id,
    person_id: person_id,
    role: role
  })
end
