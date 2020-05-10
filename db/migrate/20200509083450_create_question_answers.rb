
class CreateQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :question_answers do |t|
      t.string :answer
      t.boolean :correct, default:false
      t.integer :try, default:0
      t.references :user, foreign_key: true, null: false
      t.references :question, foreign_key: true, null: false
      t.references :problem, foreign_key: true, null: false
      t.timestamps
    end
  end
end
