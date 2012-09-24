class SubscriptionsWebservicetolaunches < ActiveRecord::Migration
  def up
    create_table :subscriptions_webservicetolaunches, :id => false do |t|
      t.references :subscription, :webservicetolaunch # Pour créer les clés etrangères
    end
  end

  def down
  end
end
