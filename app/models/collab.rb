class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles
  belongs_to :person
  validates :yt_id, :presence => true, :uniqueness => true
  before_destroy :check_roles
  audited

  def self.edges
    edges = []
    Role.all.group_by(&:person_id).each do |person_id, roles|
      roles.map{|role| role.collab_id}.uniq.combination(2).to_a.each do |first, second|
        edges += [Set[first, second]]
      end
    end
    edges.uniq!.group_by do |pair|
      edges.count(pair)
    end.map do |strength, edges_with_strength|
      [strength, edges_with_strength.map{ |e| 
        e_array = e.to_a
        {source: e_array[0], target: e_array[1]} 
      }]
    end.to_h
  end

  private
    def check_roles
      if self.roles.any?
        throw :abort
      end
    end
end
