module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[upvote downvote vote_canceling]
  end

  def upvote
    return json_errors if current_user.author_of?(@votable)

    @votable.upvote(current_user)
    json_rating
  end

  def downvote
    return json_errors if current_user.author_of?(@votable)

    @votable.downvote(current_user)
    json_rating
  end

  def vote_canceling
    return json_errors if current_user.author_of?(@votable)

    @votable.vote_canceling(current_user)
    json_rating
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def json_errors
    render json: @votable.errors.full_messages, status: :unprocessable_entity
  end

  def json_rating
    render json: { resource: @votable.class.name.downcase, rating: @votable.rating, id: @votable.id }
  end
end
