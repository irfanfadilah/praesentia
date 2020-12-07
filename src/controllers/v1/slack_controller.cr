class V1::SlackController < ApplicationController
  def online
    spawn do
      Activity.online(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def offline
    spawn do
      Activity.offline(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def away
    spawn do
      Activity.away(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def back
    spawn do
      Activity.back(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def interactivity
    spawn do
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
    end

    respond_with(200) { text "" }
  end

  def respawn
    spawn { respawn_block_instance }
    respond_with(200) { text "" }
  end

  private def update_block_instance
    BlockInstanceUpdateJob
      .new(user_id: params[:user_id], channel_id: params[:channel_id])
      .perform
  end

  private def respawn_block_instance
    BlockInstanceRespawnJob.new(channel_id: params[:channel_id]).perform
  end
end
