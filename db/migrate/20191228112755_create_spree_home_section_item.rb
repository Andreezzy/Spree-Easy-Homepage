class CreateSpreeHomeSectionItem < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_home_section_items do |t|
      t.references :home_section, index: true
      t.string :title, index: true
      t.string :subtitle, index: true
      t.string :description, index: true
      t.string :text_button, index: true
      t.string :link_button, index: true

      t.timestamps
    end
  end
end
