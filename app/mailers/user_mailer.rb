class UserMailer < ApplicationMailer

  include Rails.application.routes.url_helpers

  default from: ENV["GMAIL_USERNAME"]  # Use your email address

  def welcome_email(user,raw_password)
    @user = user
    @raw_password  = raw_password
    @login_url = login_url
    mail(to: @user.email, subject:'Welcome to Task Management App!')
  end
end
