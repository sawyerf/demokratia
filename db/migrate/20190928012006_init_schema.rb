class InitSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.string :quest
      t.text :description
      t.integer :all
    end
    create_table :users do |t|
      t.string :name
      t.string :passwd, :string
    end
    create_table :vote_logs do |t|
      t.integer :user_id
      t.integer :vote_id
      t.integer :vote
    end
    create_table :choices do |t|
      t.integer :vote
      t.string :text
      t.integer :number
    end
  end
end
