class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user.author_of?(@link.linkable)
    flash.now[:notice] = 'Your link was successfully deleted.'
  end
end
