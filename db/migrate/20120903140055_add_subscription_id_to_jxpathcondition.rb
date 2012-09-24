class AddSubscriptionIdToJxpathcondition < ActiveRecord::Migration
  def change
    add_column :jxpathconditions, :subscription_id, :integer
  end
end
