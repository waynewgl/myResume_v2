class AddUserDetailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :qalification, :text
    add_column :users, :intro, :text
    add_column :users, :skills, :string
    add_column :users, :projects, :text
  end
end
