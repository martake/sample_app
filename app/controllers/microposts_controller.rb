class MicropostsController < ApplicationController
  before_action :signed_in_user,  only: [:create, :destroy]
  before_action :correct_user,    only: :destroy

  def create

    direct_key = Message.in_direct_to_key( micropost_params[:content] )

    unless direct_key.empty?
      @message = current_user.messages.build(micropost_params)
    else
      @micropost = current_user.microposts.build(micropost_params)
    end

    if !@message.nil? && @message.save
      flash[:success] = "Message created!"
      redirect_to messages_path

    elsif !micropost.nil? && @micropost.save
      flash[:success] = "Microposts created!"
      redirect_to root_url

    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user 
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end


end
