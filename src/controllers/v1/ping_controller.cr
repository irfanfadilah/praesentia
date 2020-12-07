class V1::PingController < ApplicationController
  def index
    context.response.content_type = "application/json"
    response = {ping: true}
    response.to_json
  end
end
