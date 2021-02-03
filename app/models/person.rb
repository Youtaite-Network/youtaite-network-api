class Person < ApplicationRecord
  enum id_type: [:yt, :tw, :no_link]
  has_many :roles
  has_many :collabs, through: :roles
end