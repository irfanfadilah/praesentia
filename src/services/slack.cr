class Slack
  # event: postMessage | update | delete
  def self.run(event, body)
    HTTP::Client.post("https://slack.com/api/chat.#{event}", headers: headers, body: body)
  end

  def self.headers
    headers = HTTP::Headers{
      "Content-Type"  => "application/json",
      "Authorization" => "Bearer " + ENV["SLACK_APP_TOKEN"],
    }
  end

  def self.payload(instance, block)
    payload = {
      "channel": instance.channel_id,
      "blocks":  block,
      "as_user": true,
    }

    if instance.timestamp
      payload = payload.merge({"ts": instance.timestamp})
    end

    payload.to_json
  end

  def self.active_users(channel_id)
    ActivityTimeline.all("where user_channels.channel_id = $1 and activities.state = 'online'", [channel_id])
  end

  def self.away_users(channel_id)
    ActivityTimeline.all("where user_channels.channel_id = $1 and activities.state = 'away'", [channel_id])
  end

  def self.leave_users(channel_id)
    ActivityTimeline.all("where user_channels.channel_id = $1 and activities.state = 'leave'", [channel_id])
  end

  def self.activity_log(channel_id)
    ActivityTimeline.all("where user_channels.channel_id = $1 order by activities.updated_at desc limit 10", [channel_id])
      .reverse
  end

  def self.new_block(instance : BlockInstance)
    block = PresenceBlock.build(
      active: active_users(instance.channel_id),
      away: away_users(instance.channel_id),
      leave: leave_users(instance.channel_id),
      logs: activity_log(instance.channel_id)
    )
    response = run("postMessage", payload(instance, block))
    json = JSON.parse(response.body)
    if json["ok"].as_bool
      instance.update!(timestamp: json["ts"].as_s)
    end
  end

  def self.update_block(instance : BlockInstance)
    block = PresenceBlock.build(
      active: active_users(instance.channel_id),
      away: away_users(instance.channel_id),
      leave: leave_users(instance.channel_id),
      logs: activity_log(instance.channel_id)
    )
    response = run("update", payload(instance, block))
  end

  def self.delete_block(instance : BlockInstance)
    payload = {
      "channel": instance.channel_id,
      "ts":      instance.timestamp,
      "as_user": true,
    }

    response = run("delete", payload.to_json)
    json = JSON.parse(response.body)
    if json["ok"].as_bool
      instance.destroy
    end
  end
end
