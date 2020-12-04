class Slack
  # event: postMessage | update
  def self.run(event, instance, block)
    body = self.payload(instance, block)

    HTTP::Client.post("https://slack.com/api/chat.#{event}", headers: self.headers, body: body)
  end

  def self.headers
    headers = HTTP::Headers{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer xoxb-2176750000-1534408179079-Vb4fnD2RkvnAwR6no3f3tkEM"
    }
  end

  def self.payload(instance, block)
    payload = {
      "channel": "G01G2CXUVS9",
      "blocks": block,
      "as_user": true
    }

    if true
      payload = payload.merge({ "ts": "1607085137.001200" })
    end

    payload.to_json
  end
end
