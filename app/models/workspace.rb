class Workspace < ApplicationRecord
  WORKSPACE_PARAMS = %i(title description code is_private).freeze

  has_many :messages
  has_many :tasks
  has_many :workspace_members
  has_many :users, through: :workspace_members
  accepts_nested_attributes_for :workspace_members

  validates :title, presence: true,
    length: {maximum: 40}
  validates :code, length: {maximum: 10, minimum: 5}, allow_blank: true
  validates :description, presence: true
end
