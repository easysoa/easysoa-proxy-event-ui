class AddUserIdToNuxeotoken < ActiveRecord::Migration
  def change
    add_column :nuxeotokens, :user_id, :integer
  end
end
