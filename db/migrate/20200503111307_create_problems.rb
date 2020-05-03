class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.integer :question_style
      t.date :released_on
      t.boolean :released, default:false
      t.timestamps
    end
  end
end
