class Api::V1::WorkspaceController < ApplicationController
  before_action :get_current_user

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

  def update
    workspace = Workspace.find_by(id: params[:id])
    if workspace && can_update_workspace?(workspace, @current_user)
      if workspace.update workspace_params
        render json: {
          is_success: true,
          workspace: workspace
        }, status: :ok
      else
        render json: {
          is_success: false,
          message: workspace.errors.full_messages.join(". ")
        }, status: :ok
      end
    else
      render json: {
        is_success: false,
        message: 'Can not update this workspace!'
      }, status: :ok
    end
  end

  def show
    workspace = Workspace.find_by(id: params[:id])
    if workspace && can_read_workspace_info?(workspace, @current_user)
      render json: {
        is_success: true,
        workspace: workspace
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: 'You can not access this resource!'
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

  # POST: Add new members to workspace
  def add_members
    workspace = Workspace.find_by(id: params[:workspace_id])
    if workspace && can_add_members?(workspace, @current_user)
      params[:user_ids].map { |user_id|
        WorkspaceMember.find_or_create_by(user_id: user_id, workspace_id:params[:workspace_id])
      }
      members = workspace.users
      render json: {
        is_success: true,
        members: members
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  # POST: Remove member
  # post "workspace/:workspace_id/remove_members"
  # params: user_ids: [list uset id]
  def remove_members
    workspace = Workspace.find_by(id: params[:workspace_id])
    if workspace && can_remove_members?(workspace, @current_user)
      params[:user_ids].map { |user_id|
        workspace_member = WorkspaceMember.find_by(user_id: user_id, workspace_id: workspace.id)
        if workspace_member
          workspace_member.destroy
        end
      }
      members = workspace.users
      render json: {
        is_success: true,
        members: members
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  # GET: all users that do not belong to this workspace
  def all_users
    workspace = Workspace.find_by(id: params[:workspace_id])
    if workspace && workspace.users.pluck(:id).include?(@current_user.id)
      member_ids = workspace.users.pluck(:id)
      all_users = User.where.not(id: member_ids)
      render json: {
        is_success: true,
        users: all_users
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  # GET: all members in workspace
  def all_members
    workspace = Workspace.find_by(id: params[:workspace_id])
    if workspace && workspace.users.pluck(:id).include?(@current_user.id)
      member_ids = workspace.users.pluck(:id)
      member_ids.delete(@current_user.id)
      members = User.where(id: member_ids)
      render json: {
        is_success: true,
        members: members
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
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

  def can_add_members? workspace, user
    workspace_member = WorkspaceMember.approved.by_user_workspace(user.id, workspace.id)
    return workspace_member.present?
  end

  def can_remove_members? workspace, user
    workspace_member = WorkspaceMember.approved.by_user_workspace(user.id, workspace.id)
    return workspace_member.present?
  end

  def can_update_workspace? workspace, user
    workspace_member = WorkspaceMember.approved.by_user_workspace(user.id, workspace.id)
    return workspace_member.present?
  end

  def can_read_workspace_info? workspace, user
    workspace_member = WorkspaceMember.approved.by_user_workspace(user.id, workspace.id)
    return workspace_member.present?
  end
end
