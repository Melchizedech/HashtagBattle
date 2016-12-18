class CreateDailyHashtagCounts < ActiveRecord::Migration
  def change
    create_table :daily_hashtag_counts do |t|
      t.references :hashtag, index: true, foreign_key: true
      t.integer :count
      t.datetime :last_refresh
      t.string :last_tweet_id

      t.timestamps null: false
    end
  end
end
