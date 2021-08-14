class V1::SlackController < ApplicationController
  def interactivity
    spawn do
      data = JSON.parse params[:payload]

      if data["type"] == "view_submission"
        # Payload from Modal (Custom Status)
        states = data["view"]["state"]["values"]
        action = states["block_status"]["custom_status"]["selected_option"]["value"]
        params[:text] = states["block_message"]["custom_message"]["value"].as_s
        params[:user_id] = data["user"]["id"].as_s
        params[:channel_id] = ""
      else
        # Payload from Buttons
        action = data["actions"][0]["action_id"]
        params[:user_id] = data["user"]["id"].as_s
        params[:channel_id] = data["channel"]["id"].as_s
        params[:trigger_id] = data["trigger_id"].as_s
        params[:text] = ""
      end

      case action
      when "Online"
        ActivityUpdate.online(params)
      when "Offline"
        ActivityUpdate.offline(params)
      when "Away"
        ActivityUpdate.away(params)
      when "Leave"
        ActivityUpdate.leave(params)
      when ":speech_balloon:"
        ModalBlock.open(params)
      end
    end

    respond_with(200) { text "" }
  end

  # Below are Slash Command Actions

  # /on [message]
  def online
    spawn ActivityUpdate.online(params)
    respond_with(200) { text "" }
  end

  # /off [message]
  def offline
    spawn ActivityUpdate.offline(params)
    respond_with(200) { text "" }
  end

  # /afk [message]
  def away
    spawn ActivityUpdate.away(params)
    respond_with(200) { text "" }
  end

  # /leave [message]
  def leave
    spawn ActivityUpdate.leave(params)
    respond_with(200) { text "" }
  end

  # /respawn - Delete existing instance and repost it
  def respawn
    spawn BlockInstanceRespawnJob.new(channel_id: params[:channel_id]).perform
    respond_with(200) { text "" }
  end

  # /reinit - Post new instance based on existing instance
  def reinit
    spawn do
      instance = BlockInstance.find_by(channel_id: params[:channel_id])
      Slack.new_block(instance) if instance
    end
    respond_with(200) { text "" }
  end

  # /unlist - Remove user from a channel
  def unlist
    spawn ActivityUpdate.unlist(params)
    respond_with(200) { text "" }
  end
end
