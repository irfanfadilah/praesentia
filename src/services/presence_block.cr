class PresenceBlock

  alias BlockStr = Hash(String, String)
  alias BlockDstr = Hash(String, String | BlockStr)
  alias BlockArray = Hash(String, String | Array(BlockDstr))
  alias BlockType = BlockStr | BlockDstr | BlockArray

  getter block_array : Array(BlockType)
  getter active : Granite::Query::Builder(Activity)
  getter away : Granite::Query::Builder(Activity)
  getter logs : Granite::Query::Builder(Activity)

  def self.build(active, away, logs)
    new(active, away, logs).to_block_array
  end

  def initialize(@active, @away, @logs)
    @block_array = [] of BlockType
  end

  def text_block(type, text) : BlockType
    {
      "type" => type,
      "text" => text
    }
  end

  def header(title) : BlockType
    {
      "type" => "header",
      "text" => text_block("plain_text", title)
    }
  end

  def button(action) : BlockType
    {
      "type" => "button",
      "text" => text_block("plain_text", action),
      "action_id" => action
    }
  end

  def users_view(text) : BlockType
    {
      "type" => "section",
      "text" => text_block("mrkdwn", text)
    }
  end

  def last_logs : String
    logs.map { |elt| "<@#{elt.user_id}> is #{elt.state} \"#{elt.comment}\"" }
        .join("  \n")
  end

  def actions_block : BlockType
    {
      "type" => "actions",
      "elements" => [
        button("online"),
        button("away"),
        button("back"),
        button("offline")
      ]
    }
  end

  def to_block_array
    @block_array << header("Online")
    @block_array << users_view(stringify_user_id(@active))
    @block_array << header("Away")
    @block_array << users_view(stringify_user_id(@away))
    @block_array << header("Logs")
    @block_array << users_view(last_logs)
    @block_array << actions_block
  end

  private def stringify_user_id(users)
    users.map { |elt| "<@#{elt.user_id}>" }.join(", ")
  end
end
