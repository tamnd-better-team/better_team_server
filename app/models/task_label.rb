class TaskLabel < ApplicationRecord
  TASK_PARAMS = %i(task_id color text).freeze

  LIMIT_TASK_PER_PAGE = 5

  belongs_to :task

  validates :color, presence: true
  validates :text, presence: true
end
