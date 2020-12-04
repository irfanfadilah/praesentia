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

  def post
    Slack.run("postMessage", "instance", block)
  end

  def update
    Slack.run("update", "instance", block)
  end

  def block
    online_users = params[:online_users]
    away_users = params[:away_users]
    logs = params[:logs]

    Block.build(online_users, away_users, logs)
  end
end
