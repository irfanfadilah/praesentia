class PresenceBlock
  alias BlockStr = Hash(String, String)
  alias BlockDstr = Hash(String, String | BlockStr)
  alias BlockArray = Hash(String, String | Array(BlockDstr))
  alias BlockType = BlockStr | BlockDstr | BlockArray

  getter block_array : Array(BlockType)
  getter active : Granite::Collection(ActivityTimeline)
  getter away : Granite::Collection(ActivityTimeline)
  getter logs : Array(ActivityTimeline)

  def self.build(active, away, logs)
    new(active, away, logs).to_block_array
  end

  def initialize(@active, @away, @logs)
    @block_array = [] of BlockType
  end

  def text_block(type, text) : BlockType
    {
      "type" => type,
      "text" => text.blank? ? "---" : text,
    }
  end

  def header(title) : BlockType
    {
      "type" => "header",
      "text" => text_block("plain_text", title),
    }
  end

  def button(action) : BlockType
    {
      "type"      => "button",
      "text"      => text_block("plain_text", action),
      "action_id" => action,
    }
  end

  def users_view(text) : BlockType
    {
      "type" => "section",
      "text" => text_block("mrkdwn", text),
    }
  end

  def log_comment(user) : String
    if user.comment.to_s.blank?
      "[#{timestamp(user)}] #{indicator(user)} <@#{user.user_id}>"
    else
      "[#{timestamp(user)}] #{indicator(user)} <@#{user.user_id}>: #{user.comment}"
    end
  end

  def timestamp(user)
    unix_time = user.updated_at.not_nil!.to_s("%s")

    "<!date^#{unix_time}^{time}|¯\\_(ツ)_/¯>"
  end

  def indicator(user)
    ":is_#{user.state}:"
  end

  def last_logs : String
    logs.map { |elt| log_comment(elt) }.join("  \n")
  end

  def actions_block : BlockType
    {
      "type"     => "actions",
      "elements" => [
        button("Online"),
        button("Away"),
        button("Back"),
        button("Offline"),
      ],
    }
  end

  def to_block_array
    @block_array << header("Online")
    @block_array << users_view(stringify_user_id(@active))
    @block_array << header("Away")
    @block_array << users_view(stringify_user_id(@away))
    @block_array << header("Activities")
    @block_array << users_view(last_logs)
    @block_array << actions_block
  end

  private def stringify_user_id(users)
    users.map { |elt| "<@#{elt.user_id}>" }.join(", ")
  end
end
