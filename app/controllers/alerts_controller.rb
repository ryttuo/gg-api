class AlertsController < ApplicationController
    before_action :set_alert, only: [ :show, :update, :destroy ]

    def index
        @alerts = current_user.alerts
        render json: @alerts, status: :ok
    end

    def create
        @alert = current_user.alerts.build(alert_params)
        if @alert.save
            render json: @alert, status: :created
        else
            render json: { error: "Failed to create alert" }, status: :unprocessable_entity
        end
    end

    def show
        render json: @alert, status: :ok
    end

    def update
        if @alert.update(alert_params)
            render json: @alert, status: :ok
        else
            render json: { error: "Failed to update alert" }, status: :unprocessable_entity
        end
    end

    def destroy
        @alert.destroy
        head :no_content
    end

    private

    def set_alert
        @alert = current_user.alerts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Alert not found" }, status: :not_found
    end

    def alert_params
        params.require(:alert).permit(:name, :alert_type, :status, :description)
    end
end
