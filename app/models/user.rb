class User < ApplicationRecord
  USERS_PARAMS = %i(email first_name last_name birthday phone_number address university facebook sex avatar).freeze
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks
  has_many :messages
  has_many :task_comments
  has_many :workspace_members
  has_many :workspaces, through: :workspace_members

  validates :first_name, presence: true,
    length: {maximum: 20}
  validates :last_name, presence: true,
    length: {maximum: 20}

  scope :by_ids, ->(user_ids){where id: user_ids}
end
