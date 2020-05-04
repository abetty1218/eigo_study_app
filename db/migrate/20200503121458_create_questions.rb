class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :content
      t.string :answer
      t.string :description
      t.references :problem, foreign_key: true, null: false
      t.timestamps
    end
  end
end
