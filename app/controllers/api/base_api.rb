module Api
  class Api::BaseApi < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordNotUnique, with: :record_is_existed_before

    # implement token auth logic
    def auth_header
      request.headers['Authorization']
    end

    def token
      auth_header.split(' ')[1]
    end

    def decoded_token
      if auth_header
        JsonWebToken.decode(token)
      end
    end
    def current_user
      if decoded_token
        user_id = decoded_token['id']
        @user = User.find_by(id: user_id)
        @user.present? ? @user : false
      end
    end

    def logged_in?
      !!current_user
    end

    def authorized
      render json: "unauthenticated user", status: :unauthorized unless logged_in?
    end


    private


    def record_not_found
      render json: { error: "data not found" }, status: :not_found
    end
    
    def record_is_existed_before
      render json: {error: "data is aleady existed"}, status: :conflict
    end

  end
end