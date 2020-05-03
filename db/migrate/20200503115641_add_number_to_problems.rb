class AddNumberToProblems < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :number, :integer
    add_index :problems, :number, unique: true
  end
end
