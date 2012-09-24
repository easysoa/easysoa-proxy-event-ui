class AddWebservicetolistenIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :webservicetolisten_id, :integer
  end
end
