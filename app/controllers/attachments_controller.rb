class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])

    if current_user.author_of?(@attachment.record)
      @attachment.purge
      flash.now[:success] = 'Your attachment was successfully deleted.'
    else
      flash.now[:alert] = 'You must be author.'
      render 'questions/show'
    end
  end
end
