class TableVote < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.string :quest
      t.text :description
      t.string :vote
      t.integer :all
    end
  end
end
