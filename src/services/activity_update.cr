class ActivityUpdate
  # should wrap this under transaction :(
  def self.bump(state, params)
    activity = Activity.find_by(user_id: params[:user_id])

    if activity
      activity.update!(state: state, comment: params[:text])
    else
      activity = Activity.create!(state: state, user_id: params[:user_id], comment: params[:text])
    end

    if params[:channel_id]
      UserChannel.find_or_create_by(user_id: params[:user_id], channel_id: params[:channel_id])
    end

    update_block_instance(activity)
  end

  def self.online(params)
    bump("online", params)
  end

  def self.offline(params)
    bump("offline", params)
  end

  def self.away(params)
    bump("away", params)
  end

  def self.back(params)
    bump("back", params)
  end

  private def self.update_block_instance(activity)
    user_id = (activity.user_id || "")
    channel_id = (activity.channel_id || "")

    return if user_id == "" || channel_id == ""

    BlockInstanceUpdateJob
      .new(user_id: user_id, channel_id: channel_id)
      .perform
  end
end
