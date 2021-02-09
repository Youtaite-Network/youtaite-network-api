class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles
  belongs_to :person
  validates :yt_id, :presence => true, :uniqueness => true

  def self.edges
    edges = []
    Role.all.group_by(&:person_id).each do |person_id, roles|
      edges += roles.map{|role| role.collab_id}.uniq.combination(2).to_a
    end
    edges.uniq
  end
end
