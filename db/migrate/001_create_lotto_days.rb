class CreateLottoDays < ActiveRecord::Migration
  def self.up
    create_table :lotto_days do |t|
      t.column :description, :string
      t.column :day, :datetime
	  t.column :project_id, :integer
	  t.column :finished, :boolean
    end
  end

  def self.down
    drop_table :lotto_days
  end
end
