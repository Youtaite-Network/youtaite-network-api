class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles
  belongs_to :person
  validates :yt_id, :presence => true, :uniqueness => true
  before_destroy :check_roles
  audited

  def self.edges
    edges = []
    person_edges = []
    Role.all.group_by(&:person_id).each do |person_id, roles|
      roles.map{|role| role.collab_id}.uniq.combination(2).to_a.each do |first, second|
        min = [first, second].min
        max = [first, second].max
        edges += [[min, max]]
        person_edges.push({
          person: person_id,
          edge: {source: min, target: max},
        })
      end
    end
    # create {freq: [edges]} hash
    edges_uniq = edges.uniq
    freq_to_edges = edges_uniq.group_by do |pair|
      edges.count(pair)
    end.map do |freq, edges_with_freq|
      [freq, edges_with_freq.map{ |e| 
        e_array = e.to_a
        {source: e_array[0], target: e_array[1]} 
      }]
    end.to_h
    # create {edge: freq} hash
    edge_to_freq = {}
    freq_to_edges.each do |freq, edges|
      edges.each do |edge|
        edge_to_freq[edge] = {i: -1, l: freq}
      end
    end
    # for each elt in person_edges, add i (index) and l (length/freq)
    person_edges.map! do |pe|
      freq = edge_to_freq[pe[:edge]]
      freq[:i] += 1
      pe.merge(freq)
    end
    return {
      freq_to_edges: freq_to_edges,
      person_edges: person_edges,
    }
  end

  private
    def check_roles
      if self.roles.any?
        throw :abort
      end
    end
end
