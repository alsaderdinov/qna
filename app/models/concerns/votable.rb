module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote(user)
    votes.create(value: 1, user: user) unless already_vote?(user)
  end

  def downvote(user)
    votes.create(value: -1, user: user) unless already_vote?(user)
  end

  def vote_canceling(user)
    votes.destroy_all if already_vote?(user)
  end

  def rating
    votes.sum(:value)
  end

  def already_vote?(user)
    votes.exists?(user: user)
  end
end
