class CreateNuxeotokens < ActiveRecord::Migration
  def change
    create_table :nuxeotokens do |t|
      t.string :content
      t.timestamps
    end
  end
end
