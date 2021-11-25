class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.datetime :date, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.string :phone, null: false
      t.string :notes
      t.belongs_to :professional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
