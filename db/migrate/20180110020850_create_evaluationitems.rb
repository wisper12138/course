class CreateEvaluationitems < ActiveRecord::Migration
  def change
    create_table :evaluationitems do |t|
      t.string :itemcontent

      t.timestamps null: false
    end
  end
end
