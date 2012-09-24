class CreateCustomjxpaths < ActiveRecord::Migration
  def change
    create_table :customjxpath do |t|
      t.string :value
      t.integer :user_id

      t.timestamps
    end
  end
end
