class AddDevelopmentFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :developer_field, :string
  end
end
