class V1::SlackController < ApplicationController
  def online
    spawn do
      ActivityUpdate.online(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def offline
    spawn do
      ActivityUpdate.offline(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def away
    spawn do
      ActivityUpdate.away(params)
      update_block_instance
    end
    respond_with(200) { text "" }
  end

  def back
    spawn do
      ActivityUpdate.back(params)
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
        ActivityUpdate.online(params)
      when action == "Offline"
        ActivityUpdate.offline(params)
      when action == "Away"
        ActivityUpdate.away(params)
      when action == "Back"
        ActivityUpdate.back(params)
      end

      update_block_instance
    end

    respond_with(200) { text "" }
  end

  # Delete existing instance and repost it
  def respawn
    spawn respawn_block_instance
    respond_with(200) { text "" }
  end

  # Post new instance based on existing instance
  def reinit
    spawn do
      instance = BlockInstance.find_by(channel_id: params[:channel_id])
      Slack.new_block(instance) if instance
    end

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
