class ModalBlock
  # event: postMessage | update | delete
  def self.run(event, body)
    HTTP::Client.post("https://slack.com/api/#{event}", headers: headers, body: body)
  end

  def self.headers
    headers = HTTP::Headers{
      "Content-Type"  => "application/json",
      "Authorization" => "Bearer " + "xoxb-2176750000-1534408179079-DOqgMln3pE4COJkRFkiWs0ka",
    }
  end

  def self.open(params)
    run("views.open", build(params))
  end

  def self.build(params)
    {
      "trigger_id": params[:trigger_id],
      "view":{
        "type": "modal",
        "submit": {
          "type": "plain_text",
          "text": "Submit",
          "emoji": true
        },
        "close": {
          "type": "plain_text",
          "text": "Cancel",
          "emoji": true
        },
        "title": {
          "type": "plain_text",
          "text": "Praesentia",
          "emoji": true
        },
        "blocks": [
          {
            "type": "input",
            "block_id": "block_message",
            "element": {
              "type": "plain_text_input",
              "action_id": "custom_message",
              "emoji": true
            },
            "label": {
              "type": "plain_text",
              "text": "Message",
              "emoji": true
            }
          },
          {
            "type": "input",
            "block_id": "block_status",
            "element": {
              "type": "radio_buttons",
              "options": [
                {
                  "text": {
                    "type": "plain_text",
                    "text": "Online",
                    "emoji": true
                  },
                  "value": "Online"
                },
                {
                  "text": {
                    "type": "plain_text",
                    "text": "Away",
                    "emoji": true
                  },
                  "value": "Away"
                },
                {
                  "text": {
                    "type": "plain_text",
                    "text": "Offline",
                    "emoji": true
                  },
                  "value": "Offline"
                }
              ],
              "action_id": "custom_status"
            },
            "label": {
              "type": "plain_text",
              "text": "Status",
              "emoji": true
            }
          }
        ]
      }
    }.to_json
  end
end
