class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
