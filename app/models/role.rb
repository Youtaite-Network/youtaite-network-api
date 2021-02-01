class Role < ApplicationRecord
  enum role: [:anim, :art, :mix, :vocal]
end
