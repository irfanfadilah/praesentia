class BlockInstanceUpdateJob < Mosquito::QueuedJob
  params user_id : String, channel_id : String

  def perform
    activities = ActivityTimeline.all("where user_channels.user_id = $1", [user_id])

    instances = BlockInstance.where(:channel_id, :in, activities.map { |elt| elt.channel_id }).assembler.select.run
    current_channel_instance = current_channel(instances)
    if current_channel_instance == nil
      instance = BlockInstance.create(channel_id: channel_id)
      Slack.new_block(instance)
    else
      Slack.update_block(current_channel_instance.not_nil!)
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
