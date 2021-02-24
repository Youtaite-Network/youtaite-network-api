class Role < ApplicationRecord
  enum role: [:video, :art, :mix, :vocal, :guide, :translate, :organize, :lyrics, :script, :misc, :arrange, :instrumental, :compose]
  belongs_to :collab
  belongs_to :person
  validates :collab_id, uniqueness: { scope: [:person_id, :role] }
  audited
end
