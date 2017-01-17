class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :ble_uid
      t.string :wifi_uid
    end
  end
end
