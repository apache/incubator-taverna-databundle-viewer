class CreateDataBundles < ActiveRecord::Migration
  def change
    create_table :data_bundles do |t|
      t.string :file
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
