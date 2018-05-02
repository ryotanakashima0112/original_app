class CreateBattles < ActiveRecord::Migration[5.0]
  def change
    create_table :battles do |t|
      t.references :user, foreign_key: true
      t.references :match, foreign_key: { to_table: :users }
      t.integer :status
      t.boolean :doing, default: false, null: false

      t.timestamps
      
    end
  end
end
