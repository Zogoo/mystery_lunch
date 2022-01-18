class CreateMysteryPairs < ActiveRecord::Migration[6.1]
  def change
    create_table :mystery_pairs do |t|
      t.references :user
      t.integer :partner_id, null: false
      t.datetime :lunch_date

      t.timestamps
    end

    add_foreign_key :mystery_pairs, :users, column: :partner_id
  end
end
