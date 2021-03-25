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
      @block_array << users_row(@active) if without_comments?(@active)
      @block_array << users_with_comments(@active) if with_comments?(@active)
    end

    unless @away.empty?
      @block_array << header("Away")
      @block_array << users_row(@away) if without_comments?(@away)
      @block_array << users_with_comments(@away) if with_comments?(@away)
    end

    unless @leave.empty?
      @block_array << header("On Leave")
      @block_array << users_row(@leave) if without_comments?(@leave)
      @block_array << users_with_comments(@leave) if with_comments?(@leave)
    end

    unless @offline.empty?
      @block_array << header("Offline")
      @block_array << users_row(@offline) if without_comments?(@offline)
      @block_array << users_with_comments(@offline) if with_comments?(@offline)
    end

    @block_array << actions_block
  end

  # Private Methods

  private def with_comments?(users)
    users.reject { |u| u.comment.empty? }.size > 0
  end

  private def without_comments?(users)
    users.select { |u| u.comment.empty? }.size > 0
  end

  private def users_row(users)
    row = users
      .select { |u| u.comment.empty? }
      .map { |elt| "<@#{elt.user_id}>" }.join(", ")

    users_view(row)
  end

  private def users_with_comments(users)
    list = users
      .reject { |u| u.comment.empty? }
      .map { |user| log_comment(user) }.join("\n")

    users_view(list)
  end
end
