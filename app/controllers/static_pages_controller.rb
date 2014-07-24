class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items  = current_user.feed.paginate( page: params[:page])
    end
  end

  def rss
    @user = User.find_by( rss_token: params[:rss_token])
    @feed_items  = @user.feed
  end

  def help
  end

  def about
  end

  def constact
  end

end
