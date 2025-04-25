class AuthController < ApplicationController

    skip_before_action :authenticate_user, only: [:sign_in]

    def sign_in
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])

            jwt_token = JwtService.encode({
                user_id: @user.id,
                user_role: @user.role
            })

            response.set_cookie(
                :jwt,
                {
                    value: jwt_token,
                    httponly: true,
                    secure: false,             # Use true in production (HTTPS)
                    same_site: :lax,           # Or :strict / :none depending on your needs
                    expires: 1.hour.from_now
                }
            )

            
            set_instance_variable(self, status_message: "Success", message: "Signed in successfully")   
           

            render  "auth/signin", status: :ok

        else
            set_instance_variable(self, status_message: "Error", message: "Invalid email or password")
            render  "shared/error_response", status: :unauthorized
        end
        
    end

    def sign_out
        response.delete_cookie(:jwt, path: "/signin")
        set_instance_variable(self, status_message: "Success", message: "Signed out successfully")

        render "auth/signout", status: :ok
    end

end