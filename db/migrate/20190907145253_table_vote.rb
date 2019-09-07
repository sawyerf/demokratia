class TableVote < ActiveRecord::Migration[6.0]
  def change
    create_table :votes
    add_column :votes, :quest, :string
    add_column :votes, :for, :integer
    add_column :votes, :against, :integer
  end
end
