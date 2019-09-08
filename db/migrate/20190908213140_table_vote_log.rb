class TableVoteLog < ActiveRecord::Migration[6.0]
  def change
    create_table :vote_logs
    add_column :vote_logs, :user_id, :integer
    add_column :vote_logs, :vote_id, :integer
    add_column :vote_logs, :vote, :integer
  end
end
