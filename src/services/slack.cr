class Slack
  # event: postMessage | update
  def self.run(event, body)
    HTTP::Client.post("https://slack.com/api/chat.#{event}", headers: headers, body: body)
  end

  def self.headers
    headers = HTTP::Headers{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer xoxb-2176750000-1534408179079-Vb4fnD2RkvnAwR6no3f3tkEM"
    }
  end

  def self.payload(instance, block)
    payload = {
      "channel": instance.channel_id,
      "blocks": block,
      "as_user": true
    }

    if instance.timestamp
      payload = payload.merge({ "ts": instance.timestamp })
    end

    payload.to_json
  end

  def self.active_users(channel_id)
    Activity.where(state: "online", channel_id: channel_id)
  end

  def self.away_users(channel_id)
    Activity.where(state: "away", channel_id: channel_id)
  end

  def self.activity_log(channel_id)
    Activity.where(channel_id: channel_id)
      .order(updated_at: :desc)
      .limit(5)
  end

  def self.new_block(instance)
    block = PresenceBlock.build(
      active: active_users(instance.channel_id),
      away: away_users(instance.channel_id),
      logs: activity_log(instance.channel_id)
    )
    response = run("postMessage", payload(instance, block))
    json = JSON.parse(response.body)
    if json["ok"].as_bool
      instance.update!(timestamp: json["ts"].as_s)
    end
  end

  def self.update_block(instance)
    block = PresenceBlock.build(
      active: active_users(instance.channel_id),
      away: away_users(instance.channel_id),
      logs: activity_log(instance.channel_id)
    )
    response = run("update", payload(instance, block))
  end
end
