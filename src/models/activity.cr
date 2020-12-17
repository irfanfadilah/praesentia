class Activity < Granite::Base
  connection pg
  table activities

  column id : Int64, primary: true
  column user_id : String, unique: true
  column state : String
  column comment : String?
  column channel_id : String? # last activity at this channel
  timestamps
end
