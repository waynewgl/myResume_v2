class AddRefereesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referees, :text
  end
end
