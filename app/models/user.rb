# app/models/user.rb
class User < ApplicationRecord
  acts_as_tenant :organization

  ROLES = %w[super_admin org_admin pastor steward].freeze

  has_secure_password

  belongs_to :organization, optional: true  # super_admin no tiene
  has_one    :pastor_profile, dependent: :destroy
  has_many   :church_pastors, dependent: :destroy
  has_many   :churches, through: :church_pastors
  has_many   :refresh_tokens, dependent: :destroy

  # Como delegator (pastor que delega)
  has_many :granted_delegations,
           class_name: "Delegation",
           foreign_key: :delegator_id,
           dependent: :destroy

  # Como steward (quien recibe la delegación)
  has_many :received_delegations,
           class_name: "Delegation",
           foreign_key: :steward_id

  has_many :delegated_churches,
           through: :received_delegations,
           source: :church

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role,  inclusion: { in: ROLES }
  validates :first_name, :last_name, presence: true
  validates :organization, presence: true, unless: :super_admin?

  scope :active,   -> { where(active: true) }
  scope :pastors,  -> { where(role: "pastor") }
  scope :stewards, -> { where(role: "steward") }

  def full_name          = "#{first_name} #{last_name}"
  def super_admin?       = role == "super_admin"
  def org_admin?         = role == "org_admin"
  def pastor?            = role == "pastor"
  def steward?           = role == "steward"

  def can_submit_reports_for?(church)
    return true  if super_admin? || org_admin?
    return church.pastors.include?(self) if pastor?
    return Delegation.active_for(self, church) if steward?
    false
  end
end
