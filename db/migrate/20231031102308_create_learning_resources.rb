class CreateLearningResources < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_resources do |t|
      t.string :title
      t.string :description
      t.string :text
      t.string :link
      t.string :expertise_level
      t.integer :user_id

      t.timestamps
    end
  end
end
