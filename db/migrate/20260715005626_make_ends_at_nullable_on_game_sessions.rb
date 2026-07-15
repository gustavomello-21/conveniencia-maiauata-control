class MakeEndsAtNullableOnGameSessions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :game_sessions, :ends_at, true
  end
end
