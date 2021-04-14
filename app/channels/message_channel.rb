class MessageChannel < ApplicationCable::Channel
  def subscribed
    @workspace = Workspace.find_by(id: params[:workspace_id])
    stream_from "message_channel_#{params[:workspace_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
