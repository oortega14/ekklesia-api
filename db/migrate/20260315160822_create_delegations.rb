class CreateDelegations < ActiveRecord::Migration[8.1]
  def change
    create_table :delegations do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :church,       null: false, foreign_key: true
      t.references :delegator,
                   null: false, foreign_key: { to_table: :users }
      t.references :steward,
                   null: false, foreign_key: { to_table: :users }

      t.string :status,      null: false, default: "active"
      # "active" | "revoked" | "expired"
      t.datetime :expires_at
      t.text     :notes
      t.datetime :revoked_at
      t.references :revoked_by,
                   foreign_key: { to_table: :users },
                   index: true
      t.timestamps
    end

    add_index :delegations, [ :church_id, :steward_id ],
              unique: true, where: "status = 'active'"
    add_index :delegations, [ :organization_id, :status ]
    add_index :delegations, :expires_at
  end
end
