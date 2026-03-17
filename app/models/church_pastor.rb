# app/models/church_pastor.rb
class ChurchPastor < ApplicationRecord
  acts_as_tenant :organization

  ROLES = %w[lead associate youth worship interim].freeze

  belongs_to :organization
  belongs_to :church
  belongs_to :user

  validates :role_in_church, inclusion: { in: ROLES }
  validates :assigned_on,    presence: true
  validates :user_id,        uniqueness: { scope: :church_id, message: "ya asignado a esta iglesia" },
                             if: :active?

  scope :active, -> { where(active: true) }
  scope :leads,  -> { where(role_in_church: "lead", active: true) }
end
