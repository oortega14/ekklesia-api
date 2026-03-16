# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :set_tenant
  before_action :authenticate_user!

  private

  def set_tenant
    tenant_id = current_user_payload&.dig(:org)

    # Super admin sin org en el token → sin tenant (vista global)
    return if current_user&.super_admin? && tenant_id.nil?

    tenant = Organization.find_by(id: tenant_id)

    if tenant.nil?
      render json: { error: "Organización no encontrada" }, status: :not_found
      return
    end

    ActsAsTenant.current_tenant = tenant
  end

  def authenticate_user!
    token   = request.headers["Authorization"]&.split(" ")&.last
    payload = Auth::JwtService.decode(token)
    @current_user = User.find(payload[:sub])

    unless @current_user.active?
      render json: { error: "Cuenta desactivada" }, status: :unauthorized
    end
  rescue Auth::Errors::TokenExpired
    render json: { error: "Token expirado", code: "token_expired" },
           status: :unauthorized
  rescue Auth::Errors::TokenInvalid, ActiveRecord::RecordNotFound
    render json: { error: "No autorizado" }, status: :unauthorized
  end

  def current_user_payload
    token = request.headers["Authorization"]&.split(" ")&.last
    Auth::JwtService.decode(token) rescue nil
  end

  attr_reader :current_user
end
