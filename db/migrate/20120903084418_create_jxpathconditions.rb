class CreateJxpathconditions < ActiveRecord::Migration
  def change
    create_table :jxpathconditions do |t|
      t.string :value
      t.string :description
    end
  end
end
