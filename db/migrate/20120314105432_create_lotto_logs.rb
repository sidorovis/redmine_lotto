class CreateLottoLogs < ActiveRecord::Migration
  def self.up
    create_table :lotto_logs do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
      t.column :title, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :lotto_logs
  end
end
