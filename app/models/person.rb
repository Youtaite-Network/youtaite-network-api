class Person < ApplicationRecord
  enum id_type: [:yt, :tw, :no_link, :other, :yt_link, :ig, :fb, :soundcloud, :tumblr]
  has_many :roles
  has_many :collabs, through: :roles
  has_many :collabs
  validates :misc_id, presence: true, uniqueness: true
  audited
end
