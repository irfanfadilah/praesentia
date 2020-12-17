class BlockInstanceUpdateJob < Mosquito::QueuedJob
  params user_id : String, channel_id : String

  def perform
    activities = ActivityTimeline.all("where user_channels.user_id = ?", [user_id])
    return if activity.nil?

    instances = BlockInstance.where(channel_id: activities.map(&:channel_id))
    if instance.empty?
      instance = BlockInstance.create(channel_id: channel_id)
      Slack.new_block(instance)
    else
      Slack.update_block(current_channel(instances))
      spawn update_block_instances(other_channels(instances))
    end
  end

  private def current_channel(instances)
    instances.find { |elt| elt.channel_id == channel_id }
  end

  private def other_channels(instances)
    instances.select { |elt| elt.channel_id != channel_id }
  end

  private def update_block_instances(instances)
    instances.each { |instance| Slack.update_block(instance) }
  end
end
