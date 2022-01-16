class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # Application related items
      t.string   :photo
      t.string   :first_name
      t.string   :last_name
      t.integer  :status, null: false, default: 0
      t.string   :department, null: false, default: ''

      t.timestamps
    end
  end
end
