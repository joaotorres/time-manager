class CreateContactCenters < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_centers do |t|
      t.string :name

      t.timestamps
    end

    add_index :contact_centers, :name, unique: true
  end
end
