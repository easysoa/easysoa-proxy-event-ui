class CreateTemplatejxpaths < ActiveRecord::Migration
  def change
    create_table :templatejxpaths do |t|
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
