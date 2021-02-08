class Person < ApplicationRecord
  enum id_type: [:yt, :tw, :no_link, :other, :yt_link]
  has_many :roles
  has_many :collabs, through: :roles
  validates :misc_id, :presence => true, :uniqueness => true
end
