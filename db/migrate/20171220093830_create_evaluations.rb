class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :item
      t.integer :score

      t.timestamps null: false
    end
  end
end
