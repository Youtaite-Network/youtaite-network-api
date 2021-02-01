class Role < ApplicationRecord
  enum role: [:anim, :art, :mix, :vocal]

  belongs_to :collab
  belongs_to :person
end
