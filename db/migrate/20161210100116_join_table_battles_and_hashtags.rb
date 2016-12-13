class JoinTableBattlesAndHashtags < ActiveRecord::Migration
  def change
    create_table :battles_hashtags, id: false do |t|
      t.belongs_to :battles, index: true
      t.belongs_to :hashtags, index: true
    end
  end
end
