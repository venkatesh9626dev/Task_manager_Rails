require 'securerandom'

class Admin::UsersController < ApplicationController

  before_action :authenticate_user

  def create

    user_role = @current_user.role



    if user_role != UsersEnum::RolesEnum::ADMIN
      @status = "Error"
      @message = "Admin can only create users"
      @data = nil
      render "shared/error_response", status: :forbidden
    
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

  def show
    @user = User.find(params[:user_id])

    @status = "Success"
    @message = "Retrieved user successfully"

    render "users/show", status: :created
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    @status = "Success"
    @message = "Deleted user successfully"

    render  "users/destroy" , status: :ok
  end

  def user_params
    params.require(:user).permit(:username,:email,:role)
  end

  private

  def self.generate_random_password
    SecureRandom.alphanumeric(8)
  end

end
