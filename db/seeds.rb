module DatabaseSeeder
  include UsersHelper
  include PeopleHelper
  include TwitterApiHelper
  include YoutubeApiHelper

  def self.seed
    # Create 'auditor' user.
    # If a user's audits need to be undone, the 'undo' audits are associated with the 'auditor'.
    User.create({
      alt_user_id: "auditor",
      id_type: "system"
    })

    # Create people
    people = CSV.new(File.open("db/people.csv"))
    people.each do |row|
      if row.empty?
        next
      end

      misc_id = row[0]
      id_type = row[1]
      if id_type == "no_link"
        person_info = {
          id_type: id_type,
          name: row[2],
          misc_id: misc_id,
          thumbnail: "#"
        }
      else
        person_info = get_person_info(misc_id, id_type)
        if person_info.nil? # account might not exist anymore
          person_info = {
            id_type: :no_link,
            name: "formerly #{id_type} #{misc_id}",
            misc_id: misc_id,
            thumbnail: "#"
          }
        end
      end

      person = Person.new(person_info)
      if !person.save_without_auditing
        Rails.logger.error "Could not save #{id_type} person #{misc_id}. #{person.errors.full_messages}"
      end
    end

    # Create collabs
    collabs = CSV.new(File.open("db/collabs.csv"))
    collabs.each do |row|
      # skip if empty or already exists
      if row.empty? || Collab.find_by(yt_id: row[0])
        next
      end

      collab_info = get_collab_info row[0]
      if collab_info.nil? # video could be private/deleted
        next
      end

      # find the channel that posted the collab; if it doesn't exist in people table, create it
      owner_misc_id = collab_info[:channel_id]
      owner = Person.find_by(misc_id: owner_misc_id)
      if !owner
        owner_info = get_person_info owner_misc_id, "yt"
        owner = Person.new(owner_info)
        if !owner.save_without_auditing
          Rails.logger.error "Could not save yt person #{owner_misc_id}. #{owner.errors.full_messages}"
          next
        end
      end

      collab = Collab.new({
        yt_id: row[0],
        title: collab_info[:title],
        thumbnail: collab_info[:thumbnail],
        person_id: owner.id,
        published_at: collab_info[:published_at]
      })
      if !collab.save_without_auditing
        Rails.logger.error "Could not save collab #{row[0]}. #{collab.errors.full_messages}"
      end
    end

    # Create roles
    roles = CSV.new(File.open("db/roles.csv"))
    roles.each do |row|
      if row.empty?
        next
      end

      collab = Collab.find_by(yt_id: row[0])
      if !collab
        next
      end

      person = Person.find_by(misc_id: row[1])
      if !person
        next
      end

      collab_id = collab.id
      person_id = person.id
      role_type = row[2]
      role = Role.new({
        collab_id: collab_id,
        person_id: person_id,
        role: role_type # todo: rename role column to role_type
      })
      if !role.save_without_auditing
        Rails.logger.error "Could not save role #{role.inspect}. #{role.errors.full_messages}"
      end
    end
  end
end

DatabaseSeeder.seed
