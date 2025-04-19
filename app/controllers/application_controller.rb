class ApplicationController < ActionController::API
    before_action :authenticate_user
    # Active record validation error handling

    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

    # Jwt Error handling
    rescue_from JWT::DecodeError, JWT::ExpiredSignature, JWT::ImmatureSignature, JWT::VerificationError, JWT::InvalidIssuerError, JWT::InvalidAlgorithmError, JWT::MalformedJson, with: :handle_jwt_error

    def handle_record_invalid(exception)
        @status = "Error"
        @message = "Record Invalid: #{exception.message}"
        @data = nil
        render json: shared/response, status: :unprocessable_entity
    end

    def handle_jwt_error(exception)
        @status = "Error"
        @message = "JWT Error: #{exception.message}"
        @data = nil
        render json: shared/response, status: :unauthorized
    end

    def authenticate_user

        isAuthorized = true
        token = cookies.signed[:jwt]  # Retrieve the JWT from the signed cookie
    
        if token
          
          decoded_token = JwtService.decode(token)  # Decode the JWT to get user data
          @current_user = User.find_by(id: decoded_token[:user_id])  # Find the user based on the ID in the token
          
          isAuthorized = false unless @current_user
        else
          isAuthorized = false
        end
    
        if not isAuthorized
          @status = "Error"
          @message = "Invalid Token"
          @data = nil
          render json: "shared/response", status: :unauthorized
        
        else
          return @current_user
        end
         
    end

    def response_is_error?
        response.status >= 400 && response.status < 600
    end

    def format_error_response

    end
end
