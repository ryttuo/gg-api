class SessionsController < ApplicationController
    skip_before_action :authorized, only: [ :create ]

    def create
        @user = User.find_by(email: user_params[:email])
        if @user && @user.authenticate(user_params[:password])
            @token = encode_token({ user_id: @user.id })
            render json: { user: @user, jwt: @token }, status: :ok
        else
            render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password)
    end
end
