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

  def update
    task_id = params[:task_id]
    task = Task.find_by(id: task_id)

    time = Time.now
    Task::TASK_PARAMS.each do |field|
      if field == :start_date || field == :due_date
        if params[field].present? && Date.parse(params[field]) != task[field]
          TaskHistory.create(field: field, task_id: task.id, user_id: @current_user.id, value_before: task[field], value_after: params[field], created_at: time)
        end
      else
        if params[field].present? && params[field] != task[field]
          TaskHistory.create(field: field, task_id: task.id, user_id: @current_user.id, value_before: task[field], value_after: params[field], created_at: time)
        end
      end
    end

    if task
      if task.update task_params
        assigned_user = User.find_by(id: task.assigned_user_id)
        created_user = User.find_by(id: task.created_user_id)
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
          workspace_id: task.workspace_id,
          created_user_id: task.created_user_id,
          assigned_user_id: task.assigned_user_id,
          label: task.label,
          assigned_user_name: assigned_user ? assigned_user.get_full_name : "",
          created_user_name: created_user ? created_user.get_full_name : ""
        }
        render json: {
          is_success: true,
          task_detail: task_detail
        }, status: :ok
      else
        render json: {
          is_success: false,
          message: task.errors.full_messages.join(". ")
        }, status: :ok
      end
    else
      render json: {
        is_success: false,
        message: "You can not update this task."
      }, status: :ok
    end
  end

  # get "workspace/:workspace_id/pending_tasks_list"
  # Get all pending task in this workspace
  # params[:page] to limit records
  # params[:search_text] to search task
  def pending_tasks_list
    workspace_id = params[:workspace_id]
    search_text = params[:search_text].presence || ""
    workspace = Workspace.find_by(id: workspace_id)
    # limit_task = params[:page].to_i * Task::LIMIT_TASK_PER_PAGE

    if workspace && can_access_task?(workspace, @current_user)
      result = get_workspace_task_by_status(workspace, "pending", params[:page], search_text)
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
  # params[:search_text] to search task
  def in_progress_tasks_list
    workspace_id = params[:workspace_id]
    search_text = params[:search_text].presence || ""
    workspace = Workspace.find_by(id: workspace_id)
    # limit_task = params[:page].to_i * Task::LIMIT_TASK_PER_PAGE

    if workspace && can_access_task?(workspace, @current_user)
      result = get_workspace_task_by_status(workspace, "in_progress", params[:page], search_text)
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
  # params[:search_text] to search task
  def finished_tasks_list
    workspace_id = params[:workspace_id]
    search_text = params[:search_text].presence || ""
    workspace = Workspace.find_by(id: workspace_id)
    # limit_task = params[:page].to_i * Task::LIMIT_TASK_PER_PAGE

    if workspace && can_access_task?(workspace, @current_user)
      result = get_workspace_task_by_status(workspace, "finished", params[:page], search_text)
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
        workspace_id: task.workspace_id,
        created_user_id: task.created_user_id,
        assigned_user_id: task.assigned_user_id,
        label: task.label,
        assigned_user_name: assigned_user ? assigned_user.get_full_name : "",
        created_user_name: created_user ? created_user.get_full_name : ""
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

  def task_history
    task_histories = []

    task_updated_at = TaskHistory.where(task_id: params[:task_id]).pluck(:created_at).uniq
    task_updated_at.each do |updated_time|
      histories_at_updated_time = TaskHistory.where(task_id: params[:task_id], created_at: updated_time)

      user = histories_at_updated_time.first.user

      histories = []
      histories_at_updated_time.each do |history|
        value_before = "";
        value_after = "";

        case history.field
        when "assigned_user_id"
          value_before = User.get_full_name_by_id(history.value_before)
          value_after = User.get_full_name_by_id(history.value_after)
        when "status"
          value_before = Task::STATUS_CD[history.value_before.to_sym]
          value_after = Task::STATUS_CD[history.value_after.to_sym]
        when "priority"
          value_before = Task::PRIORITY_CD[history.value_before.to_sym]
          value_after = Task::PRIORITY_CD[history.value_after.to_sym]
        else
          value_before = history.value_before
          value_after = history.value_after
        end

        histories.push({
          field: Task::FIELDS[history.field.to_sym],
          value_before: value_before,
          value_after: value_after
        })
      end

      task_histories.push({
        updated_by: user.get_full_name,
        updated_at: histories_at_updated_time.first.created_at,
        histories: histories
      })
    end

    render json: {
      is_success: true,
      task_histories: task_histories
    }, status: :ok
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

  def get_workspace_task_by_status workspace, status, page, search_text
    task_list = []
    all_tasks = workspace.tasks.by_status(status)
      .where("title LIKE :text", text: "%#{search_text}%")
      .order_updated_at_desc
      .page(page)
      .per(Task::LIMIT_TASK_PER_PAGE)
    total = all_tasks.total_count

    all_tasks.each do |task|
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
        assigned_user_name: assigned_user ? assigned_user.get_full_name : ""
      })
    end

    {total: total, task_list: task_list}
  end
end
