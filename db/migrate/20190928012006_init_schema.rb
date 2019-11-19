class InitSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :passwd
      t.string :voter_hash
    end
    create_table :votes do |t|
      t.string :quest
      t.text :description
      t.datetime :published
      t.integer :status, default: 0
      t.string :winner, default: nil
      t.integer :voter_count, default: 0
      t.integer :choice_count, default: 0
      # Instance
      t.integer :site_id, default: 1
      t.integer :real_id
      t.datetime :updated
    end
    create_table :vote_logs do |t|
      t.integer :vote_id
      t.integer :vote
      # Instance
      t.integer :site_id
      t.string :voter_hash
      t.datetime :updated
    end
    create_table :choices do |t|
      t.integer :vote_id
      t.string :text
      t.integer :vote_count
      t.integer :index
      # Instance
      t.integer :site_id
      t.datetime :updated
    end
    create_table :sites do |t|
      t.string :domain
      t.string :mykey
      t.string :itskey
    end
    create_table :application_settings do |t|
      t.integer :vote_timeline, default: 7
      t.integer :vote_min_valid, default: 50
    end
  end
end
