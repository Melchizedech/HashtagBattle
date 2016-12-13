class AddAccessTokenAndSidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :sid, :string

  end
end
