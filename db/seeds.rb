Role.delete_all
Collab.delete_all
Person.delete_all

collabs = CSV.new(File.open('db/collabs.csv'))
collabs.each do |row|
  if row.empty?
    next
  end
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
  if row.empty?
    next
  end
  misc_id = row[0]
  thumbnail = '#'
  if row.length == 2 # twitter/misc link
    id_type = row[1]
    display_name = "@#{misc_id}"
  elsif row[0].include? '[' # no link
    id_type = :no_link
    display_name = misc_id[1..-1]
  else # yt link
    id_type = :yt
    url = 'https://youtube.googleapis.com/youtube/v3/channels?id=' + row[0] + '&key=' + ENV['GOOGLE_API_KEY'] + '&part=snippet'
    response = HTTParty.get(url).parsed_response
    display_name = response['items'][0]['snippet']['title']
    thumbnail = response['items'][0]['snippet']['thumbnails']['default']['url']
  end
  Person.create({
    misc_id: misc_id,
    id_type: id_type,
    name: display_name,
    thumbnail: thumbnail,
  })
end

roles = CSV.new(File.open('db/roles.csv'))
roles.each do |row|
  if row.empty?
    next
  end
  collab_id = Collab.find_by(yt_id: row[0]).id
  person_id = Person.find_by(misc_id: row[1]).id
  role = row[2]
  Role.create({
    collab_id: collab_id,
    person_id: person_id,
    role: role
  })
end

# REFORMAT PEOPLE.CSV
# contents = ''
# people = CSV.new(File.open('db/people_withnames.csv'))
# people.each do |row|
#   if row.length == 1 # no link associated
#     contents += row[0]
#   elsif row.length == 2 # normal
#     contents += row[1]
#   elsif row.length == 3 # twitter/misc link
#     contents += "#{row[1]},tw"
#   else
#     puts "ERROR:#{row.to_s}"
#     next
#   end
#   contents += "\n"
# end
# File.open('db/people.csv', 'w'){ |f| f.write contents }