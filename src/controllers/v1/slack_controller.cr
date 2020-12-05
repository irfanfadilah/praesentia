class V1::SlackController < ApplicationController
  def interactivity
    slack_params.validate!
    data = JSON.parse slack_params["payload"]
    action = data["actions"][0]["action_id"]

    puts data
    puts action

    respond_with(200) { text "" }
  end

  def online
    activity = Activity.online(slack_params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def offline
    activity = Activity.offline(slack_params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def away
    Activity.away(slack_params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def back
    Activity.back(slack_params)
    update_block_instance
    respond_with(200) { text "" }
  end

  private def slack_params
    params.validation do
      # Slash Commands
      optional(:channel_id)
      optional(:user_id)
      optional(:text)
      # Block Actions
      optional(:payload)
    end
  end

  private def activity_params
    slack_params.validate!

    if params["type"] == "block_actions"
      {
        channel_id: params["channel"]["id"],
        user_id: params["user"]["id"],
        text: nil
      }
    else
      params
    end
  end

  private def update_block_instance
    BlockInstanceUpdateJob
      .new(user_id: params[:user_id], channel_id: params[:channel_id])
      .perform
  end
end
