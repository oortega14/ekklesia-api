# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idiomatic so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "== Seeding database =="

# ---------------------------------------------------------------------------
# Organización base — IC Salem, Pasto, Nariño
# ---------------------------------------------------------------------------
org = Organization.find_or_create_by!(slug: "ic-salem") do |o|
  o.name         = "IC Salem"
  o.status       = "active"
  o.country_code = "CO"
end
puts "  Organization: #{org.name} (#{org.slug})"

# ---------------------------------------------------------------------------
# Super admin — Oscar Ortega
# ---------------------------------------------------------------------------
ActsAsTenant.with_tenant(org) do
  admin = User.find_or_initialize_by(email: "ortegaoscar14@gmail.com")
  admin.assign_attributes(
    first_name:   "Oscar",
    last_name:    "Ortega",
    role:         "super_admin",
    active:       true,
    organization: org
  )
  admin.password = Rails.application.credentials.superadmin.password if admin.new_record?
  admin.save!
  puts "  Super admin: #{admin.full_name} <#{admin.email}>"
end

puts "== Done =="
