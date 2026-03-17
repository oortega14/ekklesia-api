# app/controllers/api/v1/members_controller.rb
module Api
  module V1
    class MembersController < ApplicationController
      before_action :set_member, only: [ :show, :update, :destroy ]

      # GET /api/v1/members
      def index
        members = Member.includes(:church)
                        .order(:last_name, :first_name)

        render json: members.map { |m| serialize(m) }
      end

      # GET /api/v1/members/:id
      def show
        render json: serialize(@member)
      end

      # POST /api/v1/members
      def create
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        member = Member.new(member_params)
        if member.save
          render json: serialize(member), status: :created
        else
          render json: { errors: member.errors.as_json }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/members/:id
      def update
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        if @member.update(member_params)
          render json: serialize(@member)
        else
          render json: { errors: @member.errors.as_json }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/members/:id
      def destroy
        unless current_user.org_admin? || current_user.super_admin?
          render json: { error: "No autorizado" }, status: :forbidden and return
        end

        @member.destroy
        head :no_content
      end

      private

      def set_member
        @member = Member.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Miembro no encontrado" }, status: :not_found
      end

      def member_params
        params.require(:member).permit(
          :church_id, :first_name, :last_name, :email,
          :phone, :role, :status, :joined_on, :avatar_url
        )
      end

      def serialize(member)
        {
          id:          member.id,
          first_name:  member.first_name,
          last_name:   member.last_name,
          full_name:   member.full_name,
          email:       member.email,
          phone:       member.phone,
          role:        member.role,
          status:      member.status,
          joined_on:   member.joined_on,
          avatar_url:  member.avatar_url,
          church_id:   member.church_id,
          church_name: member.church&.name,
          created_at:  member.created_at
        }
      end
    end
  end
end
