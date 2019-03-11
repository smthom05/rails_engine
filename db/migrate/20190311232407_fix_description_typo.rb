class FixDescriptionTypo < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :descrption, :description
  end
end
