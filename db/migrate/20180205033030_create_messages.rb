class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :name
      t.string :phone_number
      t.text :text

      t.timestamps
    end
  end
end
