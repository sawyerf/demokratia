class InitSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :passwd, :string
      t.string :voter_hash
    end
    create_table :votes do |t|
      t.string :quest
      t.text :description
      t.datetime :published
      t.integer :voter_count
    end
    create_table :vote_logs do |t|
      t.integer :user_id
      t.integer :vote_id
      t.integer :vote
    end
    create_table :choices do |t|
      t.integer :vote_id
      t.string :text
      t.integer :vote_count
    end
    create_table :applicationsettings do |t|
      t.integer :vote_timeline, default: 7
      t.integer :vote_min_valid, default: 50
    end
  end
end
