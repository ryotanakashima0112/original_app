class ChangeDoingToBattles < ActiveRecord::Migration[5.0]
   def change
     change_column_default :battles, :doing, false
  end
end
