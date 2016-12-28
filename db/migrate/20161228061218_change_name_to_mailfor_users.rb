class ChangeNameToMailforUsers < ActiveRecord::Migration
  def change
    rename_column :users, :mail, :name
  end
end
