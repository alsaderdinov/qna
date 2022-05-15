# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    # API
    can :me, User, user_id: user.id

    # Read
    guest_abilities

    # Create
    can :create, [Question, Answer, Comment, Subscription]
    can :create_comment, [Answer, Question]

    # Update
    can :update, [Question, Answer], user_id: user.id
    can :best, Answer, question: { user_id: user.id }
    can %i[upvote downvote vote_canceling], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end

    # Destroy
    can :destroy, [Question, Answer, Subscription], user_id: user.id
    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end
end
