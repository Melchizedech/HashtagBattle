class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets, {id: false} do |t|
      t.datetime :date
      t.integer :id
      t.references :hashtag, index: true, foreign_key: true

      t.timestamps null: false
    end
    execute "ALTER TABLE tweets ADD PRIMARY KEY (id,hashtag_id);"
  end
end
