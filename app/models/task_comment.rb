class TaskComment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :content, presence: true
end
