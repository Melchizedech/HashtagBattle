class JoinTableBattlesAndHashtags < ActiveRecord::Migration
  def change
    create_table :battles_hashtags, id: false do |t|
      t.belongs_to :battle, index: true
      t.belongs_to :hashtag, index: true
    end
  end
end
