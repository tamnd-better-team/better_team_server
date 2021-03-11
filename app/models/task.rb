class Task < ApplicationRecord
  belongs_to :user
  belongs_to :workspace
  has_many :task_comments

  enum completion: {normal: 0, at_risk: 1, on_track: 2, excellent: 3}
  enum priority: {low: 0, medium: 1, high: 2}
  enum status: {new: 0, inprogress: 1, done: 2}

  validates :title, presence: true,
    length: {maximum: 100}
  validates :description, presence: true
  validates :priority, presence: true
  validates :status, presence: true
end
