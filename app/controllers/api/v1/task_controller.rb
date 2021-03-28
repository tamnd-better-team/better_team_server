class Api::V1::TaskController < ApplicationController
  # include Api::V1::TaskService

  before_action :get_current_user

  # post "workspace/:workspace_id/new_task"
  # Create new task
  def create
    user_id = @current_user.id
    params = task_params
    assigned_user_id = params[:assigned_user_id].to_i > 0 ? params[:assigned_user_id].to_i : user_id
    params[:assigned_user_id] = assigned_user_id
    task = Task.new params.merge({created_user_id: user_id, start_date: Date.today})
    if task.save
      render json: {
        is_success: true,
        task: task
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: task.errors.full_messages.join(". ")
      }, status: :ok
    end
  end

  # get "workspace/:workspace_id/pending_tasks_list"
  # Get all pending task in this workspace
  # params[:page] to limit records
  def pending_tasks_list
    workspace_id = params[:workspace_id]
    workspace = Workspace.find_by(id: workspace_id)
    limit_task = params[:page].to_i * Task::LIMIT_TASK_PER_PAGE

    if workspace && can_access_task?(workspace, @current_user)
      result = get_workspace_task_by_status(workspace, "pending", limit_task)
      render json: {
        is_success: true,
        tasks_list: result[:task_list],
        total_task: result[:total]
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  # get "workspace/:workspace_id/in_progress_tasks_list"
  # Get all in progress task in this workspace
  # params[:page] to limit records
  def in_progress_tasks_list
    workspace_id = params[:workspace_id]
    workspace = Workspace.find_by(id: workspace_id)
    limit_task = params[:page].to_i * Task::LIMIT_TASK_PER_PAGE

    if workspace && can_access_task?(workspace, @current_user)
      result = get_workspace_task_by_status(workspace, "in_progress", limit_task)
      render json: {
        is_success: true,
        tasks_list: result[:task_list],
        total_task: result[:total]
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  # get "workspace/:workspace_id/finished_tasks_list"
  # Get all finished task in this workspace
  # params[:page] to limit records
  def finished_tasks_list
    workspace_id = params[:workspace_id]
    workspace = Workspace.find_by(id: workspace_id)
    limit_task = params[:page].to_i * Task::LIMIT_TASK_PER_PAGE

    if workspace && can_access_task?(workspace, @current_user)
      result = get_workspace_task_by_status(workspace, "finished", limit_task)
      render json: {
        is_success: true,
        tasks_list: result[:task_list],
        total_task: result[:total]
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  def detail
    task = Task.find_by(id: params[:task_id])
    if task && can_access_task?(task.workspace, @current_user)
      assigned_user = User.find_by(id: task.assigned_user_id)
      created_user = User.find_by(id: task.created_user_id)
      # status = if task.status == "pending"
      #   "Pending"
      # elsif task.status == "in_progress"
      #   "In Progress"
      # elsif task.status == "finished"
      #   "Finished"
      # else
      #   "Deleted"
      # end
      task_detail = {
        id: task.id,
        priority: task.priority,
        start_date: task.start_date,
        due_date: task.due_date,
        title: task.title,
        description: task.description,
        status: task.status,
        percentage_completed: task.percentage_completed,
        created_at: task.created_at,
        updated_at: task.updated_at,
        label: task.label,
        assigned_user_name: assigned_user ? assigned_user.first_name + " " + assigned_user.last_name : "",
        created_user_name: created_user ? created_user.first_name + " " + created_user.last_name : ""
      }
      render json: {
        is_success: true,
        task_detail: task_detail
      }, status: :ok
    else
      render json: {
        is_success: false,
        message: "You can not access this recources!"
      }, status: :ok
    end
  end

  private
  def task_params
    params.permit Task::TASK_PARAMS
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

  def can_access_task? workspace, user
    workspace_member = WorkspaceMember.approved.by_user_workspace(user.id, workspace.id)
    return workspace_member.present?
  end

  def get_workspace_task_by_status workspace, status, limit_task
    task_list = []
    all_tasks = workspace.tasks.by_status(status).order_updated_at_desc
    total = all_tasks.count

    all_tasks.limit(limit_task).each do |task|
      assigned_user = User.find_by(id: task.assigned_user_id)

      task_list.push({
        id: task.id,
        priority: task.priority,
        start_date: task.start_date,
        due_date: task.due_date,
        title: task.title,
        description: task.description,
        status: task.status,
        percentage_completed: task.percentage_completed,
        created_at: task.created_at,
        updated_at: task.updated_at,
        workspace_id: task.workspace_id,
        created_user_id: task.created_user_id,
        assigned_user_id: task.assigned_user_id,
        label: task.label,
        assigned_user_name: assigned_user ? assigned_user.first_name + " " + assigned_user.last_name : ""
      })
    end

    {total: total, task_list: task_list}
  end
end
