class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])

    unless current_user.author_of?(@attachment.record)
      flash.now[:alert] = 'You must be author'
      render 'questions/show'
      return
    end

    @attachment.purge
    flash.now[:success] = 'Your attachment was successfully deleted.'
  end
end
