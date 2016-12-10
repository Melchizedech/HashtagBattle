class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.references :battle, index: true, foreign_key: true
      t.references :hashtag, index: true, foreign_key: true
      t.date :last_refresh
      t.integer :counter

      t.timestamps null: false
    end
  end
end
