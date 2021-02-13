class User < ApplicationRecord
  enum id_type: [:system, :google]
  has_many :roles
end
