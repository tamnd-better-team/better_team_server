class ApplicationController < ActionController::API

  # before_action :authenticate_user!


  def get_current_user
    auth_token = request.headers["auth-token"]
    @current_user = User.find_by(authentication_token: auth_token)
    unless @current_user
      render json: {
        messages: "You are not authorized to access this resource.",
        is_success: false
      }, status: :ok
    end
  end
end
