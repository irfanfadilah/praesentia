class ActivityUpdate
  # should wrap this under transaction :(
  def self.bump(state, params)
    activity = Activity.find_by(user_id: params[:user_id])
    activity = update_activity(activity, state, params)

    update_user_channel(activity)
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

  def self.leave(params)
    bump("leave", params)
  end

  def self.unlist(params)
    user_channel = UserChannel.find_by(user_id: params[:text], channel_id: params[:channel_id])
    return if user_channel.nil?

    user_channel.destroy
    instance = BlockInstance.find_by(channel_id: params[:channel_id])
    Slack.update_block(instance.not_nil!)
  end

  # Private Methods

  private def self.update_activity(activity, state, params)
    if activity
      if params[:channel_id].blank?
        if activity.channel_id.blank?
          activity.update!(state: state, comment: params[:text], channel_id: "G01G2CXUVS9")
        else
          activity.update!(state: state, comment: params[:text])
        end
      else
        activity.update!(state: state, comment: params[:text], channel_id: params[:channel_id])
      end
    else
      channel_id = (params[:channel_id].blank? ? "G01G2CXUVS9" : params[:channel_id])
      activity = Activity.create!(state: state, user_id: params[:user_id], channel_id: channel_id, comment: params[:text])
    end

    activity
  end

  private def self.update_user_channel(activity)
    UserChannel.find_or_create_by(user_id: activity.user_id, channel_id: activity.channel_id)
  end

  private def self.update_block_instance(activity)
    BlockInstanceUpdateJob.new(user_id: activity.user_id, channel_id: activity.channel_id).perform
  end
end
