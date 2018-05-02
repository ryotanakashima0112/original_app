class ChangeStatusToBattles < ActiveRecord::Migration[5.0]
  def up
     change_column_default :battles, :status, 0
  end
end
