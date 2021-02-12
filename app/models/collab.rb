class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles
  belongs_to :person
  validates :yt_id, :presence => true, :uniqueness => true
  before_destroy :check_roles

  def self.edges
    edges = []
    Role.all.group_by(&:person_id).each do |person_id, roles|
      edges += roles.map{|role| role.collab_id}.uniq.combination(2).to_a
    end
    edges.uniq
  end

  private
    def check_roles
      if self.roles.any?
        throw :abort
      end
    end
end
