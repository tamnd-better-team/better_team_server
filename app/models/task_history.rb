class TaskHistory < ApplicationRecord
  TASK_PARAMS = %i(user_id task_id field value_before value_after).freeze

  belongs_to :task
  belongs_to :user

  validates :field, presence: true
  validates :value_before, presence: true
  validates :value_after, presence: true
end
