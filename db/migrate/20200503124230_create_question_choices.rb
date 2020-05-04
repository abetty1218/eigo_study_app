class CreateQuestionChoices < ActiveRecord::Migration[5.1]
  def change
    create_table :question_choices do |t|
      t.boolean :choice, default:false
      t.string :content
      t.references :question, foreign_key: true, null: false
      t.timestamps
    end
  end
end
