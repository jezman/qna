class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.text :name
      t.text :url
      t.references :linkable, polymorphic: true

      t.timestamps
    end
  end
end
