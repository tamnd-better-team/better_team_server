class Workspace < ApplicationRecord
  WORKSPACE_PARAMS = %i(title description).freeze

  has_many :messages
  has_many :tasks
  has_many :workspace_members
  has_many :users, through: :workspace_members
  accepts_nested_attributes_for :workspace_members

  validates :title, presence: true,
    length: {maximum: 40}
  validates :description, presence: true
end
