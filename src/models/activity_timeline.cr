class ActivityTimeline < Granite::Base
  connection pg

  column user_id : String
  column channel_id : String
  column comment : String
  column state : String

  select_statement <<-SQL
    SELECT activities.user_id,
           user_channels.channel_id,
           activities.comment,
           activities.state
    FROM user_channels
    INNER JOIN activities
    ON activities.user_id = user_channels.user_id
  SQL
end
