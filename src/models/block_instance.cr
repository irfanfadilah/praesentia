class BlockInstance < Granite::Base
  connection pg
  table block_instances

  column id : Int64, primary: true
  column channel_id : String, unique: true
  column timestamp : String?
  timestamps
end
