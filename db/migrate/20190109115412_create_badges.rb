class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :title, null: false
      t.text :image, null: false
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
