module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

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