# app/controllers/api/v1/auth/sessions_controller.rb
module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        skip_before_action :authenticate_user!
        skip_before_action :set_tenant

        # POST /api/v1/auth/login
        def create
          result = ::Auth::AuthenticationService.login(
            email:       params[:email],
            password:    params[:password],
            device_info: {
              ip_address: request.remote_ip,
              user_agent: request.user_agent,
              device_name: request.headers["X-Device-Name"]
            }
          )

          if result.success?
            render json: session_payload(result), status: :created
          else
            render json: { error: result.error }, status: :unauthorized
          end
        end

        # POST /api/v1/auth/refresh
        def refresh
          result = ::Auth::AuthenticationService.refresh(params[:refresh_token])

          if result.success?
            render json: session_payload(result), status: :ok
          else
            render json: { error: result.error }, status: :unauthorized
          end
        end

        # DELETE /api/v1/auth/logout
        def destroy
          ::Auth::AuthenticationService.logout(params[:refresh_token])
          head :no_content
        end

        private

        def session_payload(result)
          {
            access_token:  result.access_token,
            refresh_token: result.refresh_token,
            user: {
              id:             result.user.id,
              email:          result.user.email,
              first_name:     result.user.first_name,
              last_name:      result.user.last_name,
              role:           result.user.role,
              organization_id: result.user.organization_id
            }
          }
        end
      end
    end
  end
end
