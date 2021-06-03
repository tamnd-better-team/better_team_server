class Api::V1::DashboardController < ApplicationController

  before_action :get_current_user

  def count_task_user
    user_id = @current_user.id
    tasks = Task.by_assigned_user_id(user_id)

    total_task = tasks.count
    pending_task = tasks.pending.count
    in_progress_task = tasks.in_progress.count
    finished_task = tasks.finished.count

    render json: {
      total_task: total_task,
      pending_task: pending_task,
      in_progress_task: in_progress_task,
      finished_task: finished_task
    }, status: :ok
  end

  def caculate_percent_task_changed
    user_id = @current_user.id
    tasks = Task.by_assigned_user_id(user_id)

    total_task = tasks.count
    pending_task = tasks.pending.count
    in_progress_task = tasks.in_progress.count
    finished_task = tasks.finished.count

    time = (Date.today - 7.days).beginning_of_day
    total_task_changed = tasks.before_time(time).count
    pending_task_changed = tasks.pending.before_time(time).count
    in_progress_task_changed = tasks.in_progress.before_time(time).count
    finished_task_changed = tasks.finished.before_time(time).count

    total_percent = caculate_percent(total_task_changed, total_task)
    pending_percent = caculate_percent(pending_task_changed, pending_task)
    in_progress_percent = caculate_percent(in_progress_task_changed, in_progress_task)
    finished_percent = caculate_percent(finished_task_changed, finished_task)

    render json: {
      total_percent: total_percent,
      pending_percent: pending_percent,
      in_progress_percent: in_progress_percent,
      finished_percent: finished_percent
    }, status: :ok
  end

  def get_recent_tasks
    user_id = @current_user.id
    tasks = Task.by_assigned_user_id(user_id).order_updated_at_desc.limit(10)

    recent_tasks = []
    tasks.each do |task|
      recent_tasks.push({
        id: task.id,
        workspace_title: task.workspace.title,
        title: task.title.truncate(40),
        status: task.get_status,
        percentage_completed: task.percentage_completed,
        due_date: task.due_date
      })
    end

    render json: {
      recent_tasks: recent_tasks
    }, status: :ok
  end

  def get_recent_messages
    workspaces = @current_user.workspaces

    recent_messages = []
    workspaces.each do |workspace|
      message = workspace.messages.last
      if message.present?
        recent_messages.push({
          workspace_id: workspace.id,
          workspace_title: workspace.title,
          content: message.content.truncate(100),
          user_name: message.user.get_full_name
        })
      end
    end

    render json: {
      recent_messages: recent_messages
    }, status: :ok
  end

  private
  def caculate_percent first_value, second_value
    return 0 if second_value <= 0

    ((first_value.to_f / second_value.to_f)*100.0).round
  end
end
