class TableVote < ActiveRecord::Migration[6.0]
  def change
    create_table :votes
    add_column :votes, :quest, :string
    add_column :votes, :vote, :string
  end
end
