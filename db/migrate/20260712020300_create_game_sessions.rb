class CreateGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :game_sessions do |t|
      t.string :client_name, null: false
      t.integer :session_type, null: false
      t.decimal :amount_paid, precision: 8, scale: 2
      t.datetime :started_at, null: false
      t.datetime :ends_at, null: false
      t.datetime :ended_at
      t.integer :renewals_count, default: 0
      t.integer :status, null: false

      t.timestamps
    end

    add_index :game_sessions, :status
    add_index :game_sessions, :started_at
    add_index :game_sessions, :session_type
  end
end
