require 'securerandom'

class UsersController < ApplicationController

  before_action :authenticate_user



  def index
    if @current_user.role == UsersEnum::RolesEnum::ADMIN
      @users = User.all
      set_instance_variable(self, status_message: "Success", message: "Fetched all users successfully")
      render "users/index", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "Admin can only view all users")
      render "shared/error_response", status: :forbidden
    end
  end

  def create

    user_role = @current_user.role

    if user_role != UsersEnum::RolesEnum::ADMIN
      set_instance_variable(self, status_message: "Error", message: "Admin can only create new users")
      render "shared/error_response", status: :forbidden
    
    else
      new_user_params = user_params
      new_user_params[:password] = self.class.generate_random_password
      @new_user = User.create!(new_user_params)

      UserMailer.welcome_email(@new_user,new_user_params[:password]).deliver_later

      set_instance_variable(self, status_message: "Success", message: "Created user successfully")
      render "users/create", status: :created
    end
  end

  def show
    @user = User.find(params[:id])

    set_instance_variable(self, status_message: "Success", message: "Fetched user successfully")
    render "users/show", status: :created
  end

  def destroy

    if @current_user.role == UsersEnum::RolesEnum::ADMIN
      user = User.find(params[:id])
      user.destroy

      set_instance_variable(self, status_message: "Success", message: "Deleted user successfully")
      @data = nil
      render  "users/destroy" , status: :ok

    else 
      set_instance_variable(self, status_message: "Error", message: "Admin can only delete users")
      render "shared/error_response", status: :forbidden
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
