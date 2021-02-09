class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles
  belongs_to :person
  validates :yt_id, :presence => true, :uniqueness => true

  def self.edges
    people = Person.includes(:collabs)
    edges = []
    people.each do |p|
      edges += p.collabs.pluck(:id).combination(2).to_a
    end
    edges.uniq
  end
end
