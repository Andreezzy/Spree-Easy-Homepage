module Spree
  class HomeSectionItem < Spree::Base
    #acts_as_list scope: :home_section
    has_one_attached :image
    validates :image,
      presence: true

    belongs_to :home_section, class_name: 'Spree::HomeSection', required: true
  end
end