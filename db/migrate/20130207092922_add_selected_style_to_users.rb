class AddSelectedStyleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :selected_style, :integer
  end
end
