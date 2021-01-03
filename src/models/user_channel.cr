class UserChannel < Granite::Base
  connection pg
  table user_channels

  column id : Int64, primary: true
  column user_id : String
  column channel_id : String

  timestamps
end
