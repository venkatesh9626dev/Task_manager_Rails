class Users::AuthController < ApplicationController

    skip_before_action :authenticate_user, only: [:sign_in]

    def sign_in
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])

            jwt_token = JwtService.encode({
                user_id: user.id,
                user_role: user.role
            })

            cookies.signed[:jwt] = {
                value: jwt_token,
                expires: 1.hour.from_now,   # You can adjust the expiration time as needed
                http_only: true,             # This prevents JavaScript from accessing the cookie
                same_site: :strict          # This helps mitigate CSRF attacks
            }

            @status = "Success"
            @message = "Signed in successfully"
            @data = {email: user.email, role: user.role}

            render json: "shared/response", status: :ok

        else
            @status = "Error"
            @message = "Invalid email or password"
            @data = nil
            render json: "shared/response", status: :unauthorized
        end
        
    end

    def sign_out
        cookies.delete(:jwt)
        @status = "Success"
        @message = "Signed out successfully"
        @data = nil

        render json: "json/response", status: :no_content
    end

end