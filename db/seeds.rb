include CollabsHelper
include UsersHelper
include PeopleHelper
include TwitterApiHelper

# # INITIAL SETUP
# Role.delete_all
# Person.delete_all
# Collab.delete_all
# User.delete_all

# people = CSV.new(File.open('db/people.csv'))
# people.each do |row|
#   if row.empty?
#     next
#   end
#   misc_id = row[0]
#   if row.length == 2 # twitter/misc link
#     id_type = row[1]
#   elsif row[0].include? '[' # no link
#     id_type = 'no_link'
#   else # yt link
#     id_type = 'yt'
#   end
#   display_name, thumbnail = get_person_info(misc_id, id_type).values_at(:name, :thumbnail)
#   Person.create({
#     misc_id: misc_id,
#     id_type: id_type,
#     name: display_name,
#     thumbnail: thumbnail,
#   })
# end

# collabs = CSV.new(File.open('db/collabs.csv'))
# collabs.each do |row|
#   if row.empty? or Collab.find_by(yt_id: row[0])
#     next
#   end
#   info = get_collab_info row[0]
#   if info.nil? # video could be private
#     next
#   end
#   person_misc_id = info[:channel_id]
#   person = Person.find_by(misc_id: person_misc_id)
#   if !person
#     person_info = get_person_info person_misc_id, 'yt'
#     person = Person.new({
#       misc_id: person_misc_id,
#       id_type: 'yt',
#       name: person_info[:name],
#       thumbnail: person_info[:thumbnail],
#     })
#     if !person.save
#       Rails.logger.error "Could not save person #{person_misc_id}: #{person.errors.full_messages}"
#       next
#     end
#   end
#   c = Collab.new({
#     yt_id: row[0],
#     title: info[:title],
#     thumbnail: info[:thumbnail],
#     person_id: person.id,
#   })
#   if !c.save
#     Rails.logger.error "Could not save collab #{row[0]}: #{c.errors.full_messages}"
#   end
# end

# User.create({
#   google_id: 'initial',
# })

# roles = CSV.new(File.open('db/roles.csv'))
# roles.each do |row|
#   if row.empty?
#     next
#   end
#   collab_id = Collab.find_by(yt_id: row[0]).id
#   person_id = Person.find_by(misc_id: row[1]).id
#   user_id = User.find_by(google_id: 'initial').id
#   role = row[2]
#   r = Role.new({
#     collab_id: collab_id,
#     person_id: person_id,
#     user_id: user_id,
#     role: role,
#   })
#   r.save
#   puts r.errors.full_messages
# end

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

# # GENERATE PERSON_ID FOR COLLABS
# Collab.all.each do |collab|
#   if collab.person_id
#     next
#   end
#   person_misc_id = get_collab_info(collab.yt_id)[:channel_id]
#   person = Person.find_by(misc_id: person_misc_id)
#   if !person
#     person_info = get_person_info person_misc_id, 'yt'
#     person = Person.new({
#       misc_id: person_misc_id,
#       id_type: 'yt',
#       name: person_info[:name],
#       thumbnail: person_info[:thumbnail],
#     })
#     if !person.save
#       Rails.logger.error "Could not save person #{person_misc_id}: #{person.errors.full_messages}"
#     end
#   end
#   collab.person_id = person.id
#   if !collab.save
#     Rails.logger.error "Could not save collab #{collab.yt_id}: #{collab.errors.full_messages}"
#   end
# end

# GENERATE PERSON INFO FOR TW PEOPLE
Person.where(id_type: 'tw').each do |person|
  info = get_tw_person_from_url person.misc_id
  if !info
    Rails.logger.error "Could not retrieve information for tw person: #{person.misc_id}."
    next
  end
  person.name = info[:name]
  person.misc_id = info[:misc_id]
  person.thumbnail = info[:thumbnail]
  if !person.save
    Rails.logger.error "Could not save tw person: #{person.name}. #{person.errors.full_messages}"
  end
end
