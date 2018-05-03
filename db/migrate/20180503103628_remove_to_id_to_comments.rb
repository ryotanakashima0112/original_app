class RemoveToIdToComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :to_id, :integer
  end
end
