class AddColumnsToNuxeoToken < ActiveRecord::Migration
  def change
    add_column :nuxeotokens, :token, :string
    add_column :nuxeotokens, :secret, :string
    remove_column :nuxeotokens, :content
  end
end
