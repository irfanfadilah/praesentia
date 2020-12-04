class Activity < Granite::Base
  connection pg
  table activities

  column id : Int64, primary: true
  column user_id : String, unique: true
  column state : String
  column comment : String?
  timestamps

  def self.bump(state, user_id, comment)
    activity = Activity.find_by(user_id: user_id)
    if activity
      activity.update!(state: state, comment: comment)
    else
      Activity.create!(state: state, user_id: user_id, comment: comment)
    end
  end

  def self.online(user_id, comment)
    bump("online", user_id, comment)
  end

  def self.offline(user_id, comment)
    bump("offline", user_id, comment)
  end

  def self.away(user_id, comment)
    bump("away", user_id, comment)
  end

  def self.back(user_id, comment)
    bump("back", user_id, comment)
  end
end
