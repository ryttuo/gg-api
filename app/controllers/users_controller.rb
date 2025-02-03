class UsersController < ApplicationController
    skip_before_action :authorized, only: [ :create ]

    def create
        @user = User.new(params.require(:user).permit(:email, :password))

        existing_user = User.find_by(email: params[:user][:email])
        if existing_user
            render json: { error: "Email already exists" }, status: :unprocessable_entity
        elsif @user.save
            @token = encode_token({ user_id: @user.id })
            render json: { user: @user, jwt: @token }, status: :created
        else
            render json: { error: "Failed to create user" }, status: :unprocessable_entity
        end
    end

    def show
        render json: current_user, status: :ok
    end

    def update
        if current_user.update(user_params)
            render json: current_user, status: :ok
        else
            render json: { error: "Failed to update user" }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :phone, :email, :role, :password)
    end
end
