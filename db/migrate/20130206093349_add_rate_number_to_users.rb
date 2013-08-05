class AddRateNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rate_number, :integer
  end
end
