require 'securerandom'

class Users::UsersController < ApplicationController

  before_action :authenticate_user

  def create

    user_role = @current_user.role.upcase

    if user_role != UsersEnum::RolesEnum::ADMIN
      @status = "Error"
      @message = "Admin can only create users"
      @data = nil
      render json: "shared/response", status: :forbidden
    
    else
      new_user_params = user_params
      new_user_params[:password] = self.class.generate_random_password
      @new_user = User.create!(new_user_params)

      UserMailer.welcome_email(@new_user,new_user_params[:password]).deliver_later

      @status = "Success"
      @message = "Created user successfully"

      render "users/create", status: :created
    end
  end

  def user_params
    params.require(:user).permit(:username,:email,:role)
  end

  private

  def self.generate_random_password
    SecureRandom.alphanumeric(8)
  end

end
