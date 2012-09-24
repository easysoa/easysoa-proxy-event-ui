class CreateSubscriptionTypes < ActiveRecord::Migration
  def change
    create_table :subscription_types do |t|
      t.string :description
      t.string :title

      t.timestamps
    end
  end
end
