# app/models/church.rb
class Church < ApplicationRecord
  acts_as_tenant :organization

  STATUSES = %w[active inactive plant].freeze

  belongs_to :organization
  belongs_to :lead_pastor, class_name: "User", optional: true

  has_many :church_pastors, dependent: :destroy
  has_many :pastors,        through: :church_pastors, source: :user

  has_many :services,             dependent: :destroy
  has_many :attendance_reports,   dependent: :destroy
  has_many :offering_reports,     dependent: :destroy
  has_many :delegations,          dependent: :destroy

  validates :name,         presence: true
  validates :status,       inclusion: { in: STATUSES }
  validates :country_code, presence: true,
                           length: { is: 2 },
                           format: { with: /\A[A-Z]{2}\z/, message: "debe ser código ISO de 2 letras (ej: CO)" }
  validates :email,        format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  before_validation :normalize_country_code

  scope :active,   -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }
  scope :plants,   -> { where(status: "plant") }

  def full_address
    parts = [ address_line, city, state_province, country_code ].compact_blank
    parts.join(", ")
  end

  private

  def normalize_country_code
    self.country_code = country_code.to_s.strip.upcase if country_code.present?
  end
end
