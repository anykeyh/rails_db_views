class CreateTestTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, index: true

      t.timestamps null: false
    end

    create_table :user_messages do |t|
      t.integer :from_id, index: true
      t.integer :to_id, index: true

      t.text :content

      t.timestamps null: false
    end
  end
end
