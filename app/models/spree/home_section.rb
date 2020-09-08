module Spree
  class HomeSection < Spree::Base
    include Spree::ProductIdsProcessable
    acts_as_list

    has_many :home_section_products, dependent: :destroy
    has_many :products, through: :home_section_products, source: :product

    has_many :home_section_items, dependent: :destroy

    alias_attribute :sections, :home_section_products
    alias_attribute :items, :home_section_items

    accepts_nested_attributes_for :home_section_items, allow_destroy: true

    after_save :force_delete_sections, :add_products_by_id

    attr_accessor :product_ids, :force_delete

    enum section_type: { main_banner: 0, banner_2: 1, banner_3: 2, banner_text: 3, banner_products: 4 }

    #validations
    validates_presence_of :title, :section_type, :internal_name
    validates_inclusion_of :visible, :in => [true, false]

    def get_images_size_for_banner
      num_of_images = [1, 2, 3, 1, 0]
      num_of_images[Spree::HomeSection.section_types[self.section_type]]
    end
    
    def delete_sections
      home_section_products.delete_all
    end

    def product_ids?
      product_ids.present?
    end

    def force_delete?
      force_delete.present?
    end

    def products_by_position
      products.order(sections_asc_query)
    end

    def section_products?
      home_section_products.any?
    end

    protected

    def force_delete_sections
      return unless force_delete?

      delete_sections
    end

    def add_products_by_id
      return unless product_ids?

      add_products(product_ids: product_ids)
    end

    private

    def sections_asc_query
      'spree_home_section_products.position ASC'
    end
  end
end
