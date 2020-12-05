class V1::SlackController < ApplicationController
  def online
    Activity.online(params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def offline
    Activity.offline(params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def away
    Activity.away(params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def back
    Activity.back(params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def interactivity
    data = JSON.parse params[:payload]
    action = data["actions"][0]["action_id"]

    params[:user_id] = data["user"]["id"].as_s
    params[:channel_id] = data["channel"]["id"].as_s
    params[:text] = ""

    case
    when action == "Online"
      Activity.online(params)
    when action == "Offline"
      Activity.offline(params)
    when action == "Away"
      Activity.away(params)
    when action == "Back"
      Activity.back(params)
    end

    update_block_instance
    respond_with(200) { text "" }
  end

  private def update_block_instance
    BlockInstanceUpdateJob
      .new(user_id: params[:user_id], channel_id: params[:channel_id])
      .perform
  end
end
