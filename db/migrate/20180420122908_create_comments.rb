class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :from_id
      t.integer :to_id
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
