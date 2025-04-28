require 'securerandom'

class UsersController < ApplicationController

  before_action :validate_admin, only: [ :create, :destroy]

  def index
    @users = User.all
    set_instance_variable(self, status_message: "Success", message: "Fetched all users successfully")
    render "users/index", status: :ok
  end

  def create
    new_user_params = user_params
    new_user_params[:password] = self.generate_random_password
    puts "Password: #{new_user_params[:password]}"
    @new_user = User.new(new_user_params)

    if @new_user.invalid?
      set_instance_variable(self, status_message: "Error", message: @new_user.errors.full_messages)
      render "shared/error_response", status: :unprocessable_entity
    else
      @new_user.save
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
    user = User.find(params[:id])
    user.destroy
    set_instance_variable(self, status_message: "Success", message: "Deleted user successfully")
    render  "users/destroy" , status: :ok

  end
 

  private

  def user_params
    params.require(:user).permit(:username,:email,:role)
  end

  def generate_random_password
    SecureRandom.hex(4)
  end

end
