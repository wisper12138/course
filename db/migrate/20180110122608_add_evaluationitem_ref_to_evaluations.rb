class AddEvaluationitemRefToEvaluations < ActiveRecord::Migration
  def change
    add_reference :evaluations, :evaluationitem, index: true, foreign_key: true
  end
end
