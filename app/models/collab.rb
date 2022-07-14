class Collab < ApplicationRecord
  has_many :roles
  has_many :people, through: :roles
  belongs_to :person
  validates :yt_id, presence: true, uniqueness: true
  before_destroy :check_roles
  audited

  def self.edges
    person_edges = []
    Role.all.group_by(&:person_id).each do |person_id, roles|
      roles.map { |role| role.collab_id }.uniq.combination(2).to_a.each do |first, second|
        min = [first, second].min
        max = [first, second].max
        person_edges.push({
          person: person_id,
          edge: [min, max]
        })
      end
    end
    # create {[source, target] => freq}
    edge_to_freq = person_edges.map { |pe| pe[:edge] }
      .group_by(&:itself)
      .transform_values!(&:size)
    {
      freq_to_edges: calc_freq_to_edges(edge_to_freq),
      person_edges: calc_person_edges(person_edges, edge_to_freq)
    }
  end

  # Create and return a hash from frequency (aka edge weight)
  # to an array of hashes, where each represents an edge
  # with a source and a target
  private_class_method def self.calc_freq_to_edges edge_to_freq
    # create {freq => [[source, target], ...]} hash
    freq_to_edges = {}
    edge_to_freq.each do |edge, freq|
      freq_to_edges[freq] = (freq_to_edges[freq] || []) + [edge]
    end
    # map to {freq: [{source, target}, ...], ...}
    freq_to_edges.map do |freq, edges|
      [freq, edges.map { |e| edge_to_h(e) }]
    end.to_h
  end

  private_class_method def self.calc_person_edges person_edges, edge_to_freq
    # create {edge: {index, length}} hash
    edge_to_index_length = edge_to_freq.map do |edge, freq|
      [edge, {i: -1, l: freq}]
    end.to_h
    # for each elt in person_edges, add i (index) and l (length/freq)
    person_edges.map do |pe|
      freq = edge_to_index_length[pe[:edge]]
      freq[:i] += 1
      {
        person: pe[:person],
        edge: edge_to_h(pe[:edge]),
        i: freq[:i],
        l: freq[:l]
      }
    end
  end

  # Transform an edge with format [source, target] to {source, target}
  private_class_method def self.edge_to_h edge
    source, target = edge
    {source: source, target: target}
  end

  private

  def check_roles
    if roles.any?
      throw :abort
    end
  end
end
