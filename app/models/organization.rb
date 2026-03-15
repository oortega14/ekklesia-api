# app/models/organization.rb
class Organization < ApplicationRecord
  STATUSES = %w[active suspended trial].freeze

  has_many :users,                dependent: :destroy
  has_many :churches,             dependent: :destroy
  has_many :services,             dependent: :destroy
  has_many :attendance_reports,   dependent: :destroy
  has_many :offering_reports,     dependent: :destroy
  has_many :membership_snapshots, dependent: :destroy
  has_many :delegations,          dependent: :destroy
  has_many :audit_logs

  validates :name,    presence: true
  validates :slug,    presence: true,
                      uniqueness: true,
                      format: { with: /\A[a-z0-9\-]+\z/ }
  validates :status,  inclusion: { in: STATUSES }

  scope :active, -> { where(status: "active") }

  def trial_expired?
    trial_ends_on.present? && trial_ends_on < Date.current
  end
end
