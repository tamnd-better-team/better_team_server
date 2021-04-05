class TaskComment < ApplicationRecord
  TASK_COMMENT_PARAMS = %i(content).freeze

  belongs_to :task
  belongs_to :user

  validates :content, presence: true
end
