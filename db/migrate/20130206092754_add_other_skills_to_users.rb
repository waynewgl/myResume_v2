class AddOtherSkillsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_skills, :text
  end
end
