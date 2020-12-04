class Block
  def self.build(online_users="-", away_users="-", logs="-")
    [
      {
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": "Online"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": online_users
        }
      },
      {
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": "Away"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": away_users
        }
      },
      {
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": "Logs"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": logs
        }
      },
      {
        "type": "actions",
        "elements": [
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Online"
            },
            "action_id": "online"
          },
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Away"
            },
            "action_id": "away"
          },
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Back"
            },
            "action_id": "back"
          },
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Offline"
            },
            "action_id": "offline"
          }
        ]
      }
    ]
  end
end
