class CreateLottoDayResults < ActiveRecord::Migration
  def self.up
    create_table :lotto_day_results do |t|
      t.column :price, :double
      t.column :lotto_day_id, :integer
	  t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :lotto_day_results
  end
end
