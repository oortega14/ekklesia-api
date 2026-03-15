# app/models/delegation.rb
class Delegation < ApplicationRecord
  acts_as_tenant :organization

  STATUSES = %w[active revoked expired].freeze

  belongs_to :organization
  belongs_to :church
  belongs_to :delegator,  class_name: "User"
  belongs_to :steward,    class_name: "User",
                          foreign_key: :steward_id
  belongs_to :revoked_by, class_name: "User", optional: true

  validates :status, inclusion: { in: STATUSES }
  validate  :delegator_must_be_assigned_to_church
  validate  :steward_must_not_be_pastor
  validate  :expires_at_must_be_future, on: :create

  scope :active, -> {
    where(status: "active")
      .where("expires_at IS NULL OR expires_at > ?", Time.current)
  }

  def self.active_for(steward, church)
    active.exists?(steward: steward, church: church)
  end

  def self.expire_stale!
    where(status: "active")
      .where("expires_at <= ?", Time.current)
      .update_all(status: "expired")
  end

  def revoke!(by_user:)
    update!(
      status:     "revoked",
      revoked_at: Time.current,
      revoked_by: by_user
    )
  end

  private

  def delegator_must_be_assigned_to_church
    return unless delegator && church
    unless church.pastors.include?(delegator)
      errors.add(:delegator, "no es pastor de esta iglesia")
    end
  end

  def steward_must_not_be_pastor
    return unless steward
    if steward.pastor?
      errors.add(:steward, "un pastor no puede ser steward")
    end
  end

  def expires_at_must_be_future
    if expires_at.present? && expires_at <= Time.current
      errors.add(:expires_at, "debe ser una fecha futura")
    end
  end
end
