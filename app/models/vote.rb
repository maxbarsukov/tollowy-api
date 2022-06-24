# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  votable_type :string           not null
#  vote_flag    :boolean
#  vote_scope   :string
#  vote_weight  :integer
#  voter_type   :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  votable_id   :bigint           not null
#  voter_id     :bigint           not null
#
# Indexes
#
#  index_votes_on_votable                                     (votable_type,votable_id)
#  index_votes_on_votable_id_and_votable_type_and_vote_scope  (votable_id,votable_type,vote_scope)
#  index_votes_on_voter                                       (voter_type,voter_id)
#  index_votes_on_voter_id_and_voter_type_and_vote_scope      (voter_id,voter_type,vote_scope)
#
Vote = ActsAsVotable::Vote

class Vote
  VOTABLE_TYPES = %w[Post].freeze

  validates :votable_type, :voter_type, presence: true
  validates :votable_type, presence: true, inclusion: { in: VOTABLE_TYPES }
end
