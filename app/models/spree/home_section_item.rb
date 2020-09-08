module Spree
  class HomeSectionItem < Spree::Base
    #acts_as_list scope: :home_section
    has_one_attached :image
    validates_presence_of :image, :unless => lambda { self.home_section.banner_text? }

    belongs_to :home_section, class_name: 'Spree::HomeSection', required: true
  end
end