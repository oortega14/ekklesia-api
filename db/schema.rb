# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_16_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendance_reports", force: :cascade do |t|
    t.integer "adults"
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.integer "children"
    t.datetime "created_at", null: false
    t.integer "first_time", default: 0
    t.integer "members"
    t.integer "men"
    t.integer "new_visitors", default: 0
    t.text "notes"
    t.integer "online_viewers", default: 0
    t.bigint "organization_id", null: false
    t.bigint "responsible_pastor_id"
    t.integer "seniors"
    t.bigint "service_id", null: false
    t.string "status", default: "draft", null: false
    t.datetime "submitted_at"
    t.bigint "submitted_by_id", null: false
    t.integer "total_attendees", null: false
    t.datetime "updated_at", null: false
    t.integer "women"
    t.integer "youth"
    t.index ["approved_by_id"], name: "index_attendance_reports_on_approved_by_id"
    t.index ["organization_id", "status"], name: "index_attendance_reports_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_attendance_reports_on_organization_id"
    t.index ["responsible_pastor_id"], name: "index_attendance_reports_on_responsible_pastor_id"
    t.index ["service_id"], name: "index_attendance_reports_on_service_id", unique: true
    t.index ["submitted_at"], name: "index_attendance_reports_on_submitted_at"
    t.index ["submitted_by_id"], name: "index_attendance_reports_on_submitted_by_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "actor_id", null: false
    t.jsonb "changes_snapshot", default: {}
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.bigint "organization_id"
    t.bigint "resource_id"
    t.string "resource_type", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["actor_id"], name: "index_audit_logs_on_actor_id"
    t.index ["organization_id", "created_at"], name: "index_audit_logs_on_organization_id_and_created_at"
    t.index ["organization_id"], name: "index_audit_logs_on_organization_id"
    t.index ["resource_type", "resource_id"], name: "index_audit_logs_on_resource_type_and_resource_id"
  end

  create_table "church_pastors", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.date "assigned_on", null: false
    t.bigint "church_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.bigint "organization_id", null: false
    t.date "released_on"
    t.string "role_in_church", default: "associate", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["church_id", "user_id"], name: "index_church_pastors_on_church_id_and_user_id", unique: true, where: "(active = true)"
    t.index ["church_id"], name: "index_church_pastors_on_church_id"
    t.index ["organization_id", "active"], name: "index_church_pastors_on_organization_id_and_active"
    t.index ["organization_id"], name: "index_church_pastors_on_organization_id"
    t.index ["user_id"], name: "index_church_pastors_on_user_id"
  end

  create_table "churches", force: :cascade do |t|
    t.text "address_line"
    t.string "city"
    t.string "country_code", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.date "founded_on"
    t.decimal "latitude", precision: 10, scale: 7
    t.bigint "lead_pastor_id"
    t.decimal "longitude", precision: 10, scale: 7
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.string "phone"
    t.jsonb "settings", default: {}, null: false
    t.string "state_province"
    t.string "status", default: "active", null: false
    t.string "timezone", default: "America/Bogota"
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_churches_on_latitude_and_longitude"
    t.index ["lead_pastor_id"], name: "index_churches_on_lead_pastor_id"
    t.index ["organization_id", "status"], name: "index_churches_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_churches_on_organization_id"
  end

  create_table "delegations", force: :cascade do |t|
    t.bigint "church_id", null: false
    t.datetime "created_at", null: false
    t.bigint "delegator_id", null: false
    t.datetime "expires_at"
    t.text "notes"
    t.bigint "organization_id", null: false
    t.datetime "revoked_at"
    t.bigint "revoked_by_id"
    t.string "status", default: "active", null: false
    t.bigint "steward_id", null: false
    t.datetime "updated_at", null: false
    t.index ["church_id", "steward_id"], name: "index_delegations_on_church_id_and_steward_id", unique: true, where: "((status)::text = 'active'::text)"
    t.index ["church_id"], name: "index_delegations_on_church_id"
    t.index ["delegator_id"], name: "index_delegations_on_delegator_id"
    t.index ["expires_at"], name: "index_delegations_on_expires_at"
    t.index ["organization_id", "status"], name: "index_delegations_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_delegations_on_organization_id"
    t.index ["revoked_by_id"], name: "index_delegations_on_revoked_by_id"
    t.index ["steward_id"], name: "index_delegations_on_steward_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "avatar_url"
    t.bigint "church_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name", null: false
    t.date "joined_on"
    t.string "last_name", null: false
    t.bigint "organization_id", null: false
    t.string "phone"
    t.string "role", default: "member", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["church_id"], name: "index_members_on_church_id"
    t.index ["email"], name: "index_members_on_email"
    t.index ["organization_id", "church_id"], name: "index_members_on_organization_id_and_church_id"
    t.index ["organization_id", "status"], name: "index_members_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_members_on_organization_id"
  end

  create_table "membership_snapshots", force: :cascade do |t|
    t.integer "active_members", null: false
    t.bigint "church_id", null: false
    t.datetime "created_at", null: false
    t.integer "deceased", default: 0
    t.integer "inactive", default: 0
    t.integer "new_this_month", default: 0
    t.bigint "organization_id", null: false
    t.date "snapshot_date", null: false
    t.integer "total_members", null: false
    t.integer "transferred_in", default: 0
    t.integer "transferred_out", default: 0
    t.datetime "updated_at", null: false
    t.index ["church_id"], name: "index_membership_snapshots_on_church_id"
    t.index ["organization_id", "church_id", "snapshot_date"], name: "idx_membership_snapshots_unique", unique: true
    t.index ["organization_id"], name: "index_membership_snapshots_on_organization_id"
  end

  create_table "offering_reports", force: :cascade do |t|
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.jsonb "breakdown", default: {}, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "COP", null: false
    t.decimal "missions_fund", precision: 14, scale: 2, default: "0.0"
    t.text "notes"
    t.decimal "offerings", precision: 14, scale: 2, default: "0.0"
    t.bigint "organization_id", null: false
    t.bigint "responsible_pastor_id"
    t.bigint "service_id", null: false
    t.decimal "special_offerings", precision: 14, scale: 2, default: "0.0"
    t.string "status", default: "draft", null: false
    t.datetime "submitted_at"
    t.bigint "submitted_by_id", null: false
    t.decimal "tithes", precision: 14, scale: 2, default: "0.0"
    t.decimal "total", precision: 14, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_offering_reports_on_approved_by_id"
    t.index ["organization_id", "status"], name: "index_offering_reports_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_offering_reports_on_organization_id"
    t.index ["responsible_pastor_id"], name: "index_offering_reports_on_responsible_pastor_id"
    t.index ["service_id"], name: "index_offering_reports_on_service_id", unique: true
    t.index ["submitted_at"], name: "index_offering_reports_on_submitted_at"
    t.index ["submitted_by_id"], name: "index_offering_reports_on_submitted_by_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "country_code", default: "CO", null: false
    t.datetime "created_at", null: false
    t.string "default_currency", default: "COP", null: false
    t.string "default_locale", default: "es", null: false
    t.string "default_timezone", default: "America/Bogota", null: false
    t.string "logo_url"
    t.string "name", null: false
    t.jsonb "settings", default: {}, null: false
    t.string "slug", null: false
    t.string "status", default: "active", null: false
    t.date "trial_ends_on"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
    t.index ["status"], name: "index_organizations_on_status"
  end

  create_table "pastor_profiles", force: :cascade do |t|
    t.boolean "available_for_transfer", default: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "languages", default: ["es"], array: true
    t.date "ordained_on"
    t.string "ordaining_body"
    t.bigint "organization_id", null: false
    t.string "specialties", default: [], array: true
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["organization_id"], name: "index_pastor_profiles_on_organization_id"
    t.index ["user_id"], name: "index_pastor_profiles_on_user_id", unique: true
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "device_name"
    t.datetime "expires_at", null: false
    t.string "ip_address"
    t.string "jti", null: false
    t.bigint "organization_id"
    t.string "revoke_reason"
    t.datetime "revoked_at"
    t.string "token_digest", null: false
    t.string "token_hmac", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["expires_at"], name: "index_refresh_tokens_on_expires_at"
    t.index ["jti"], name: "index_refresh_tokens_on_jti", unique: true
    t.index ["organization_id"], name: "index_refresh_tokens_on_organization_id"
    t.index ["token_digest"], name: "index_refresh_tokens_on_token_digest", unique: true
    t.index ["token_hmac"], name: "index_refresh_tokens_on_token_hmac", unique: true
    t.index ["user_id", "revoked_at"], name: "index_refresh_tokens_on_user_id_and_revoked_at"
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "church_id", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.text "description"
    t.integer "duration_minutes", default: 90
    t.string "location_note"
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.datetime "scheduled_at", null: false
    t.string "service_type", default: "sunday", null: false
    t.string "status", default: "scheduled", null: false
    t.datetime "updated_at", null: false
    t.index ["church_id"], name: "index_services_on_church_id"
    t.index ["created_by_id"], name: "index_services_on_created_by_id"
    t.index ["organization_id", "church_id", "scheduled_at"], name: "idx_on_organization_id_church_id_scheduled_at_8d7c365892"
    t.index ["organization_id", "status"], name: "index_services_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_services_on_organization_id"
    t.index ["service_type"], name: "index_services_on_service_type"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "locale", default: "es"
    t.bigint "organization_id"
    t.string "password_digest", null: false
    t.string "phone"
    t.string "role", default: "steward", null: false
    t.string "timezone"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id", "active"], name: "index_users_on_organization_id_and_active"
    t.index ["organization_id", "role"], name: "index_users_on_organization_id_and_role"
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "attendance_reports", "organizations"
  add_foreign_key "attendance_reports", "services"
  add_foreign_key "attendance_reports", "users", column: "approved_by_id"
  add_foreign_key "attendance_reports", "users", column: "responsible_pastor_id"
  add_foreign_key "attendance_reports", "users", column: "submitted_by_id"
  add_foreign_key "audit_logs", "organizations"
  add_foreign_key "audit_logs", "users", column: "actor_id"
  add_foreign_key "church_pastors", "churches"
  add_foreign_key "church_pastors", "organizations"
  add_foreign_key "church_pastors", "users"
  add_foreign_key "churches", "organizations"
  add_foreign_key "churches", "users", column: "lead_pastor_id"
  add_foreign_key "delegations", "churches"
  add_foreign_key "delegations", "organizations"
  add_foreign_key "delegations", "users", column: "delegator_id"
  add_foreign_key "delegations", "users", column: "revoked_by_id"
  add_foreign_key "delegations", "users", column: "steward_id"
  add_foreign_key "members", "churches"
  add_foreign_key "members", "organizations"
  add_foreign_key "membership_snapshots", "churches"
  add_foreign_key "membership_snapshots", "organizations"
  add_foreign_key "offering_reports", "organizations"
  add_foreign_key "offering_reports", "services"
  add_foreign_key "offering_reports", "users", column: "approved_by_id"
  add_foreign_key "offering_reports", "users", column: "responsible_pastor_id"
  add_foreign_key "offering_reports", "users", column: "submitted_by_id"
  add_foreign_key "pastor_profiles", "organizations"
  add_foreign_key "pastor_profiles", "users"
  add_foreign_key "refresh_tokens", "organizations"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "services", "churches"
  add_foreign_key "services", "organizations"
  add_foreign_key "services", "users", column: "created_by_id"
  add_foreign_key "users", "organizations"
end
