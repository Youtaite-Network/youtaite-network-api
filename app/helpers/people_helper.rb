module PeopleHelper
  def get_person_info misc_id, id_type
    person = Person.find_by(misc_id: misc_id)
    return person if person
    if id_type == 'yt'
      info = get_yt_person_info_from_id misc_id
    elsif id_type == 'tw'
      info = get_tw_person_info_from_id misc_id
    else # no_link, other, ig, yt_link
      info = {
        name: misc_id,
        thumbnail: '#',
      }
    end
    if !info
      Rails.logger.error "Could not get info about person with id_type #{id_type} and misc_id #{misc_id}."
      return
    end
    return {
      id_type: id_type,
      misc_id: misc_id,
      name: info[:name],
      thumbnail: info[:thumbnail],
    }
  end
end