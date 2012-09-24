class CreateWebservicetolaunches < ActiveRecord::Migration
  def change
    create_table :webservicetolaunches do |t|
      t.string :description
      t.string :environment
      t.string :nuxeouid
      t.string :url

      t.timestamps
    end
  end
end
