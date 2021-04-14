class Api::V1::AccountController < ApplicationController
  before_action :get_current_user, only: %i(index update)

  def index
    if @current_user
      render json: {
        messages: "Successfully",
        is_success: true,
        user: @current_user
      }, status: :ok
    else
      render json: {
        messages: "You are not authorized to access this source.",
        is_success: false
      }, status: :ok
    end
  end

  def update
    if @current_user
      if @current_user.update user_params
        render json: {
          messages: "Successfully",
          is_success: true,
          user: @current_user
        }, status: :ok
      else
        render json: {
          messages: "Update faild.",
          is_success: false,
          errors: @current_user.errors.full_messages.join(". ")
        }, status: :ok
      end
    else
      render json: {
        messages: "You are not authorized to access this source.",
        is_success: false
      }, status: :ok
    end
  end

  private
  def user_params
    params.permit User::USERS_PARAMS
  end
end
