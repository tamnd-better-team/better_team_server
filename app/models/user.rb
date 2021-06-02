class User < ApplicationRecord
  USERS_PARAMS = %i(email first_name last_name birthday phone_number address university facebook sex avatar).freeze
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages
  has_many :task_comments
  has_many :workspace_members
  has_many :workspaces, through: :workspace_members
  has_many :task_history
  has_many :reply_messages

  validates :first_name, presence: true,
    length: {maximum: 20}
  validates :last_name, presence: true,
    length: {maximum: 20}

  scope :without_authen_token, ->{select(User.column_names - ["authentication_token"])}
  scope :by_ids, ->(user_ids){where id: user_ids}

  def get_full_name
    self.first_name + " " + self.last_name
  end

  class << self
    def get_full_name_by_id(id)
      user = User.find_by(id: id)
      if user
        user.first_name + " " + user.last_name
      else
        ""
      end
    end
  end
end
