class RenameTitleColumnToPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :title, :title
  end
end
