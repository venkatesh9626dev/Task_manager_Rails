class ApplicationController < ActionController::API

    include ActionController::Cookies

    #icluded this instance setter to set instance variables
    include Shared::InstanceSetter

    before_action :authenticate_user
    # Active record validation error handling

    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # Jwt Error handling
    rescue_from JWT::DecodeError, JWT::ExpiredSignature, JWT::ImmatureSignature, JWT::InvalidIssuerError, JWT::InvalidIatError, JWT::InvalidAudError, JWT::VerificationError, JWT::IncorrectAlgorithm, with: :handle_jwt_error

    def handle_record_invalid(exception)
        @status_message = "Error"
        @message = "Record Invalid: #{exception.message}"

        render "shared/error_response", status: :unprocessable_entity
    end

    def record_not_found(exception)
        @status_message = "Error"
        @message = "Record Not Found: #{exception.message}"

        render "shared/error_response", status: :not_found
    end

    def handle_jwt_error(exception)
        @status_message = "Error"
        @message = "JWT Error: #{exception.message}"

        render "shared/error_response", status: :unauthorized
    end

    def authenticate_user

        isAuthorized = true
        token = cookies[:jwt]  # Retrieve the JWT from the signed cookie
    
        if token
          
          decoded_token = JwtService.decode(token)  # Decode the JWT to get user data
          @current_user = User.find_by(id: decoded_token[:user_id])  # Find the user based on the ID in the token
          
          isAuthorized = false unless @current_user
        else
          isAuthorized = false
        end
    
        if not isAuthorized
          @status_message = "Error"
          @message = "Invalid Token"
          render "shared/error_response", status: :unauthorized
        end
         
    end

    def validate_admin
        if @current_user.role != UsersEnum::RolesEnum::ADMIN
            set_instance_variable(self, status_message: "Error", message: "Admin can only view all users")
            render "shared/error_response", status: :forbidden
        end
    end
    
    def status=(status)
        @status_message = status
    end

    def message=(message)
        @message = message
    end

end
