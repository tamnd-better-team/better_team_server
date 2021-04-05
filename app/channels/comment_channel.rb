class CommentChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "task_comment_channel"
    @task = Task.find_by(id: params[:task_id])
    stream_from "comment_channel_#{params[:task_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
