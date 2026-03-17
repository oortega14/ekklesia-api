# app/models/member.rb
class Member < ApplicationRecord
  acts_as_tenant :organization

  ROLES = %w[member deacon elder cell_leader musician coordinator volunteer].freeze
  STATUSES = %w[active inactive pending].freeze

  belongs_to :organization
  belongs_to :church

  validates :first_name, :last_name, presence: true
  validates :role,   inclusion: { in: ROLES }
  validates :status, inclusion: { in: STATUSES }
  validates :email,  format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :active,   -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }
  scope :pending,  -> { where(status: "pending") }

  def full_name = "#{first_name} #{last_name}"
end
