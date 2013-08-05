class AddExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experience, :text
  end
end
