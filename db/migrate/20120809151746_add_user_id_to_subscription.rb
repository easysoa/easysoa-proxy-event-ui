class AddUserIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :user_id, :integer
  end
  def down
    delete_columns :subscriptions, :user_id
  end
end
