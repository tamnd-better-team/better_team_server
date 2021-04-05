class Api::V1::TaskCommentController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :get_current_user

  def create
    task = Task.find_by(id: params[:task_id])
    comment = TaskComment.new task_comment_params.merge({
      user_id: @current_user.id,
      task_id: params[:task_id]
    })
    if comment.save
      comments = get_comments(params[:task_id])
      ActionCable.server.broadcast "comment_channel_#{params[:task_id]}", { data: comments }
    end
  end

  def comments
    if params[:task_id] && Task.find_by(params[:task_id])
      comments = get_comments(params[:task_id])
      render json: {
        is_success: true,
        comments: comments
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this resources."
      }, status: :ok
    end
  end

  private
  def task_comment_params
    params.permit TaskComment::TASK_COMMENT_PARAMS
  end

  def get_current_user
    auth_token = request.headers["auth-token"]
    @current_user = User.find_by(authentication_token: auth_token)
    unless @current_user
      render json: {
        messages: "You are not authorized to access this resource.",
        is_success: false
      }, status: :ok
    end
  end

  def get_comments(task_id)
    task_comments = TaskComment.where(task_id: task_id)
    comments = []
    task_comments.each do |comment|
      comments.push({
        content: comment.content,
        time: time_ago_in_words(comment.created_at),
        user_name: comment.user.get_full_name
      })
    end
    comments
  end
end
