class Role < ApplicationRecord
  enum role: [:video, :art, :mix, :vocal, :guide, :translate, :organize, :lyrics, :script, :misc]
  belongs_to :collab
  belongs_to :person
  belongs_to :user
end
