# app/controllers/api/v1/churches_controller.rb
module Api
  module V1
    class ChurchesController < ApplicationController
      before_action :set_church, only: [ :show, :update, :destroy ]

      # GET /api/v1/churches
      def index
        churches = Church.includes(:lead_pastor)
                         .order(:name)
                         .select(:id, :name, :status, :country_code,
                                 :city, :state_province, :address_line,
                                 :phone, :email, :founded_on,
                                 :lead_pastor_id, :timezone, :created_at)

        render json: churches.map { |c| serialize(c) }
      end

      # GET /api/v1/churches/:id
      def show
        render json: serialize(@church)
      end

      # POST /api/v1/churches
      def create
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        church = Church.new(church_params)
        if church.save
          render json: serialize(church), status: :created
        else
          render json: { errors: church.errors.as_json }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/churches/:id
      def update
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        if @church.update(church_params)
          render json: serialize(@church)
        else
          render json: { errors: @church.errors.as_json }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/churches/:id
      def destroy
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        @church.destroy
        head :no_content
      end

      private

      def set_church
        @church = Church.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Iglesia no encontrada" }, status: :not_found
      end

      def church_params
        params.require(:church).permit(
          :name, :status,
          :country_code, :city, :state_province, :address_line,
          :latitude, :longitude, :timezone,
          :phone, :email, :founded_on,
          :lead_pastor_id
        )
      end

      def serialize(church)
        {
          id:             church.id,
          name:           church.name,
          status:         church.status,
          country_code:   church.country_code,
          city:           church.city,
          state_province: church.state_province,
          address_line:   church.address_line,
          phone:          church.phone,
          email:          church.email,
          founded_on:     church.founded_on,
          lead_pastor_id: church.lead_pastor_id,
          timezone:       church.timezone,
          created_at:     church.created_at
        }
      end
    end
  end
end
