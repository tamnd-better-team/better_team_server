class Message < ApplicationRecord
  MESSAGE_PARAMS = %i(content).freeze

  belongs_to :user
  belongs_to :workspace
  has_many :reply_messages

  validates :content, presence: true
end
