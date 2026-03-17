# app/models/pastor_profile.rb
class PastorProfile < ApplicationRecord
  acts_as_tenant :organization

  belongs_to :organization
  belongs_to :user

  validates :user_id, uniqueness: { scope: :organization_id }
end
