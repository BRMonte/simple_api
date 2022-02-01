class Api::V1::SessionsController < Devise::RegistrationsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create

  #sign_in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in("user", @user)
      json_response("Signed in successfully", true, {user: @user}, :ok)
    else
      json_response("Unauthorized", false, {}, :unauthorized)
    end
  end

  private
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])

    if @user
      return @user
    else
      json_response("Canot get user", false, {}, :failure)
    end
  end
end
