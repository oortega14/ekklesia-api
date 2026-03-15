class MembershipSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :membership_snapshots do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :church,       null: false, foreign_key: true

      t.date     :snapshot_date,    null: false
      t.integer  :total_members,    null: false
      t.integer  :active_members,   null: false
      t.integer  :new_this_month,   default: 0
      t.integer  :transferred_in,   default: 0
      t.integer  :transferred_out,  default: 0
      t.integer  :deceased,         default: 0
      t.integer  :inactive,         default: 0
      t.timestamps
    end

    add_index :membership_snapshots,
              [ :organization_id, :church_id, :snapshot_date ],
              unique: true,
              name: "idx_membership_snapshots_unique"
  end
end
