class Message < ApplicationRecord
  MESSAGE_PARAMS = %i(content).freeze

  belongs_to :user
  belongs_to :workspace

  validates :content, presence: true
end
