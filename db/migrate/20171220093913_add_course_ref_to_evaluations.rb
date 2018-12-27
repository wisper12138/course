class AddCourseRefToEvaluations < ActiveRecord::Migration
  def change
    add_reference :evaluations, :course, index: true, foreign_key: true
  end
end
