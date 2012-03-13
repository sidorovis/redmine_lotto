class CreateLottoBets < ActiveRecord::Migration
  def self.up
    create_table :lotto_bets do |t|
      t.column :lotto_day_id, :integer
      t.column :user_id, :integer
      t.column :price, :double
      t.column :description, :string
	  t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :lotto_bets
  end
end
