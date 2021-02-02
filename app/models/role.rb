class Role < ApplicationRecord
  enum role: [:video, :art, :mix, :vocal, :guide, :translate, :organize, :lyrics, :misc]
  belongs_to :collab
  belongs_to :person
end
