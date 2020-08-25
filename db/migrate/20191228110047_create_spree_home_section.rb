class CreateSpreeHomeSection < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_home_sections do |t|
      t.string :title
      t.string :internal_name
      t.integer :position, index: true
      t.integer :section_type
      t.boolean :visible

      t.timestamps
    end
  end
end
