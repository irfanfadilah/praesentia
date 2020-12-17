class UserChannel < Granite::Base
  connection pg
  table user_channels

  column id : Int64, primary: true
  timestamps
end
