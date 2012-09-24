class ProxiesSubscriptions < ActiveRecord::Migration

  def change
    add_column :subscriptions, :proxy_id, :integer
  end
end
