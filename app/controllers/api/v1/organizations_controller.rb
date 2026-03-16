# app/controllers/api/v1/organizations_controller.rb
module Api
  module V1
    class OrganizationsController < ApplicationController
      # GET /api/v1/organizations
      # Solo super_admin puede listar todas las organizaciones
      def index
        unless current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden
          return
        end

        orgs = Organization.order(:name).select(:id, :name, :slug, :status)
        render json: orgs
      end
    end
  end
end
