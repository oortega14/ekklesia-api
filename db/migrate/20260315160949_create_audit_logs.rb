class CreateAuditLogs < ActiveRecord::Migration[8.1]
   def change
    create_table :audit_logs do |t|
      t.references :organization, foreign_key: true
      # null para acciones de super_admin
      t.references :actor,
                   null: false, foreign_key: { to_table: :users }

      t.string  :action,        null: false
      # "created" | "updated" | "deleted" | "approved" |
      # "revoked" | "login" | "logout"
      t.string  :resource_type, null: false   # "AttendanceReport"
      t.bigint  :resource_id                  # 42
      t.jsonb   :changes_snapshot, default: {} # before/after
      t.string  :ip_address
      t.string  :user_agent
      t.timestamps
    end

    add_index :audit_logs, [ :organization_id, :created_at ]
    add_index :audit_logs, [ :resource_type, :resource_id ]
    add_index :audit_logs, :actor_id
  end
end
