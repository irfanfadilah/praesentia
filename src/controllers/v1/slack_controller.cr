class V1::SlackController < ApplicationController
  def online
    Activity.online(params[:user_id], params[:text])
    respond_with { text "<@#{params[:user_id]}> just checked in: #{params[:text]}" }
  end

  def offline
    Activity.offline(params[:user_id], params[:text])
    respond_with { text "<@#{params[:user_id]}> just checked out: #{params[:text]}" }
  end

  def away
    Activity.away(params[:user_id], params[:text])
    respond_with { text "<@#{params[:user_id]}> is away: #{params[:text]}" }
  end

  def back
    Activity.back(params[:user_id], params[:text])
    respond_with { text "<@#{params[:user_id]}> is back: #{params[:text]}" }
  end
end
