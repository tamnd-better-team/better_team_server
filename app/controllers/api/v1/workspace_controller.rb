class Api::V1::WorkspaceController < ApplicationController
  before_action :get_current_user, only: %i(user_list_workspace create)

  def create
    user_id = @current_user.id
    workspace = Workspace.new workspace_params
    if workspace.save
      workspace_member = WorkspaceMember.new(role: :admin, user_id: user_id, workspace_id: workspace.id)
      if workspace_member.save
        render json: {
          is_success: true,
          workspace: {
            id: workspace.id,
            title: workspace.title
          }
        }, status: :ok
      end
    else
      render json: {
        is_success: false,
        error: workspace.errors.full_messages.join(". ")
      }, status: :ok
    end
  end

  def user_list_workspace
    workspaces = @current_user.workspaces.select(:id, :title)
    render json: {
      is_success: true,
      workspaces: workspaces
    }, status: :ok
  end

  private
  def workspace_params
    params.permit Workspace::WORKSPACE_PARAMS
  end

  def get_current_user
    auth_token = request.headers["auth-token"]
    @current_user = User.find_by(authentication_token: auth_token)
    unless @current_user
      render json: {
        messages: "You are not authorized to access this source.",
        is_success: false
      }, status: :ok
    end
  end
end
