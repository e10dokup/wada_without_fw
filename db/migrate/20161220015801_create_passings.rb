class CreatePassings < ActiveRecord::Migration[5.0]
  def change
    create_table :passings do |t|
      t.datetime :passing_at, null: false
      t.string :object_address, null: false
      t.string :subject_address, null: false
      t.string :app_id, null: false

      t.timestamp
    end
  end
end
