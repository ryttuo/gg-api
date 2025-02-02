class CreateAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :alerts do |t|
      t.string :name
      t.string :alert_type
      t.boolean :status
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
