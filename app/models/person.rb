class Person < ApplicationRecord
  has_many :roles
  has_many :collabs, through: :roles
end
