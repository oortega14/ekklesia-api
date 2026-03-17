# app/controllers/api/v1/pastors_controller.rb
module Api
  module V1
    class PastorsController < ApplicationController
      before_action :set_pastor, only: [ :show, :update, :destroy ]

      # GET /api/v1/pastors
      def index
        pastors = User.pastors
                      .includes(:pastor_profile, church_pastors: :church)
                      .order(:last_name, :first_name)

        render json: pastors.map { |u| serialize(u) }
      end

      # GET /api/v1/pastors/:id
      def show
        render json: serialize(@pastor)
      end

      # POST /api/v1/pastors
      def create
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        pastor = User.new(pastor_params.merge(role: "pastor"))
        if pastor.save
          render json: serialize(pastor), status: :created
        else
          render json: { errors: pastor.errors.as_json }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/pastors/:id
      def update
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        if @pastor.update(update_params)
          render json: serialize(@pastor)
        else
          render json: { errors: @pastor.errors.as_json }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/pastors/:id
      def destroy
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        @pastor.destroy
        head :no_content
      end

      private

      def set_pastor
        @pastor = User.pastors.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Pastor no encontrado" }, status: :not_found
      end

      def pastor_params
        params.require(:pastor).permit(
          :first_name, :last_name, :email, :password,
          :phone, :active, :avatar_url, :timezone
        )
      end

      def update_params
        params.require(:pastor).permit(
          :first_name, :last_name, :email,
          :phone, :active, :avatar_url, :timezone
        )
      end

      def serialize(user)
        churches = user.church_pastors.select(&:active).map do |cp|
          { id: cp.church_id, name: cp.church&.name, role: cp.role_in_church }
        end

        {
          id:         user.id,
          first_name: user.first_name,
          last_name:  user.last_name,
          full_name:  user.full_name,
          email:      user.email,
          phone:      user.phone,
          active:     user.active,
          avatar_url: user.avatar_url,
          created_at: user.created_at,
          churches:   churches
        }
      end
    end
  end
end
