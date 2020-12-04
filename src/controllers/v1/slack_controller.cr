class V1::SlackController < ApplicationController
  def online
    activity = Activity.online(params)
    update_block_instance
    respond_with(200) { text "" }
  end

  def offline
    activity = Activity.offline(params)
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

  private def update_block_instance
    BlockInstanceUpdateJob
      .new(user_id: params[:user_id], channel_id: params[:channel_id])
      .perform
  end
end
