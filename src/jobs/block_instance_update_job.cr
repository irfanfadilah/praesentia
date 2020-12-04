class BlockInstanceUpdateJob < Mosquito::QueuedJob
  params user_id : String, channel_id : String

  def perform
    activity = Activity.find_by(user_id: user_id)
    return if activity.nil?

    instance = BlockInstance.find_by(channel_id: channel_id)
    if instance.nil?
      instance = BlockInstance.create(channel_id: channel_id)
      Slack.new_block(instance)
    else
      Slack.update_block(instance)
    end
  end
end
