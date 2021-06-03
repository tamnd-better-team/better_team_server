class Task < ApplicationRecord
  TASK_PARAMS = %i(completion priority start_date due_date title description type status percentage_completed workspace_id created_user_id assigned_user_id).freeze

  FIELDS = {
    completion: "Completion",
    priority: "Priority",
    start_date: "Start Date",
    due_date: "Due Date",
    title: "Title",
    description: "Description",
    type: "Type",
    status: "Status",
    percentage_completed: "Percentage Completed",
    assigned_user_id: "Assigned"
  }

  PRIORITY_CD =  {
    low: "Low",
    normal: "Normal",
    high: "High"
  }

  STATUS_CD = {
    pending: "Pending",
    in_progress: "In Progress",
    finished: "Finished",
    deleted: "Deleted"
  }

  LIMIT_TASK_PER_PAGE = 5

  belongs_to :workspace
  has_many :task_comments
  has_many :task_labels
  has_many :task_history

  # enum completion: {normal: 0, at_risk: 1, on_track: 2, excellent: 3}
  enum priority: {low: 0, normal: 1, high: 2}
  enum status: {pending: 0, in_progress: 1, finished: 2, deleted: 3}

  validates :title, presence: true,
    length: {maximum: 100}
  validates :description, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  validates :due_date, presence: true

  scope :order_updated_at_desc, ->{order(updated_at: :desc)}
  scope :order_created_at_desc, ->{order(created_at: :desc)}
  scope :by_status, ->(status){where status: status}
  scope :by_assigned_user_id, ->(user_id){where(assigned_user_id: user_id)}
  scope :before_time, ->(time){where("updated_at > ?", time)}

  def get_status
    case self.status
    when "pending"
      "Pending"
    when "in_progress"
      "In progress"
    when "finished"
      "Finished"
    when "deleted"
      "Deleted"
    else
      ""
    end
  end
end
