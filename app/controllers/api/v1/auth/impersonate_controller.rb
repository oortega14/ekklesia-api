# app/controllers/api/v1/auth/impersonate_controller.rb
module Api
  module V1
    module Auth
      class ImpersonateController < ApplicationController
        skip_before_action :set_tenant

        # POST /api/v1/auth/impersonate
        def create
          unless current_user.super_admin?
            render json: { error: "No autorizado" }, status: :forbidden
            return
          end

          result = ::Auth::AuthenticationService.impersonate(
            user:            current_user,
            organization_id: params[:organization_id],
            device_info: {
              ip_address:  request.remote_ip,
              user_agent:  request.user_agent,
              device_name: request.headers["X-Device-Name"]
            }
          )

          if result.success?
            render json: {
              access_token:  result.access_token,
              refresh_token: result.refresh_token,
              organization_id: params[:organization_id].to_i
            }, status: :created
          else
            render json: { error: result.error }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
