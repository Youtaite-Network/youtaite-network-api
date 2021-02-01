class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles

  def self.edges
    people = Person.includes(:collabs)
    edges = []
    people.each do |p|
      edges += p.collabs.pluck(:id).combination(2).to_a
    end
    edges.uniq
  end
end
