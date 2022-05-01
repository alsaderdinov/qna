module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: %i[create_comment]
    after_action :publish_comment, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      'comments',
      {
        comment: ApplicationController.render(
          partial: 'comments/comment',
          locals: {
            comment: @comment
          }
        ),
        comment_id: @comment.id,
        user: @comment.user_id,
        commentable_type: @comment.commentable_type.downcase
      }
    )
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
