class ActivityUpdate
  # should wrap this under transaction :(
  def self.bump(state, params)
    activity = Activity.find_by(user_id: params[:user_id])
    if activity
      activity.update!(state: state, comment: params[:text])
    else
      Activity.create!(state: state, user_id: params[:user_id], comment: params[:text])
    end
    UserChannel.find_or_create_by(user_id: params[:user_id], channel_id: params[:channel_id])
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
    bump("back", params)
  end
end
