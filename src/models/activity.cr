class Activity < Granite::Base
  connection pg
  table activities

  column id : Int64, primary: true
  column user_id : String, unique: true
  column state : String
  column comment : String?
  column channel_id : String?
  timestamps

  def self.bump(state, params)
    activity = Activity.find_by(user_id: params[:user_id])
    if activity
      activity.update!(state: state, comment: params[:text], channel_id: params[:channel_id])
    else
      Activity.create!(state: state, user_id: params[:user_id], comment: params[:text], channel_id: params[:channel_id])
    end
  end

  def self.online(params)
    bump("online", params)
  end

  def self.offline(params)
    bump("offline", params)
  end

  def self.away(params)
    bump("away", params)
  end

  def self.back(params)
    bump("online", params)
  end
end
