class CreateWebservicetolistens < ActiveRecord::Migration
  def change
    create_table :webservicetolistens do |t|
      t.string :archipath
      t.datetime :date
      t.string :description
      t.string :environment
      t.string :nuxeouid
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
