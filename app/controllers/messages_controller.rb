class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

  def index
      @feed_items  = current_user.feed_direct.paginate( page: params[:page])
      @micropost = Micropost.new
  end

  def destroy
    @message.destroy
    redirect_to messages_path
  end

  private

    def correct_user 
      @message = current_user.messages.find_by(id: params[:id])
      redirect_to messages_path if @message.nil?
    end

end
