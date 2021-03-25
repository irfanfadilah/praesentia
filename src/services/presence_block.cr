class PresenceBlock
  alias BlockStr = Hash(String, String)
  alias BlockDstr = Hash(String, String | BlockStr)
  alias BlockArray = Hash(String, String | Array(BlockDstr))
  alias BlockType = BlockStr | BlockDstr | BlockArray

  getter block_array : Array(BlockType)
  getter active : Granite::Collection(ActivityTimeline)
  getter away : Granite::Collection(ActivityTimeline)
  getter leave : Granite::Collection(ActivityTimeline)
  getter offline : Granite::Collection(ActivityTimeline)

  def self.build(active, away, leave, offline)
    new(active, away, leave, offline).to_block_array
  end

  def initialize(@active, @away, @leave, @offline)
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

  def users_with_comment(users)
    users
      .select { |u| u.comment.present? }
      .map { |user| log_comment(user) }
  end

  def log_comment(user) : String
    "[#{timestamp(user)}] #{indicator(user)} <@#{user.user_id}>: #{user.comment}"
  end

  def timestamp(user)
    unix_time = user.updated_at.not_nil!.to_s("%s")

    "<!date^#{unix_time}^{time}|¯\\_(ツ)_/¯>"
  end

  def indicator(user)
    ":is_#{user.state}:"
  end

  def actions_block : BlockType
    {
      "type"     => "actions",
      "elements" => [
        button("Online"),
        button("Away"),
        button("Leave"),
        button("Offline"),
        button(":speech_balloon:")
      ],
    }
  end

  def to_block_array
    unless @active.empty?
      @block_array << header("Online")
      @block_array << users_view(stringify_user_id(@active))
      @block_array << users_with_comment(@active)
    end

    unless @away.empty?
      @block_array << header("Away")
      @block_array << users_view(stringify_user_id(@away))
      @block_array << users_with_comment(@away)
    end

    unless @leave.empty?
      @block_array << header("On Leave")
      @block_array << users_view(stringify_user_id(@leave))
      @block_array << users_with_comment(@leave)
    end

    unless @offline.empty?
      @block_array << header("Offline")
      @block_array << users_view(stringify_user_id(@offline))
      @block_array << users_with_comment(@offline)
    end

    @block_array << actions_block
  end

  private def stringify_user_id(users)
    users
      .select { |u| u.comment.blank? }
      .map { |elt| "<@#{elt.user_id}>" }.join(", ")
  end
end
