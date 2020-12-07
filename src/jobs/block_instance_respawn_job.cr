class BlockInstanceRespawnJob < Mosquito::QueuedJob
  params channel_id : String

  def perform
    instance = BlockInstance.find_by(channel_id: channel_id)
    return if instance.nil?
    Slack.delete_block(instance)

    instance = BlockInstance.create(channel_id: channel_id)
    Slack.new_block(instance)
  end
end
