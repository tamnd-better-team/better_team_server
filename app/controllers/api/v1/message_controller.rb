class Api::V1::MessageController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :get_current_user

  def create
    workspace_id = params[:workspace_id]
    message = Message.new message_params.merge({
      user_id: @current_user.id,
      workspace_id: workspace_id
    })
    if message.save
      messages = get_messages(workspace_id)
      ActionCable.server.broadcast "message_channel_#{params[:workspace_id]}", { data: messages }
      # render json: {
      #   is_success: true,
      #   messages: messages
      # }, status: :ok
    end
  end

  def messages
    workspace_id = params[:workspace_id]
    workspace_member = WorkspaceMember.find_by(user_id: @current_user.id, workspace_id: workspace_id)
    if workspace_member
      messages = get_messages(workspace_id)
      render json: {
        is_success: true,
        messages: messages
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this resources."
      }, status: :ok
    end
  end

  private
  def message_params
    params.permit Message::MESSAGE_PARAMS
  end

  def get_messages(workspace_id)
    workspace = Workspace.find_by(id: workspace_id)
    messages = []
    workspace.messages.each do |message|
      messages.push({
        content: message.content,
        time: time_ago_in_words(message.created_at),
        user_name: message.user.get_full_name
      })
    end
    messages
  end
end
