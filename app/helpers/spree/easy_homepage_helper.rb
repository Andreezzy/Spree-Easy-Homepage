module Spree
  module EasyHomepageHelper
    include Spree::ProductsHelper

    def fill_with_sections(partial: home_section_partial, **partial_args)
      get_homesection_partial(partial: partial, **partial_args)
    end

    def home_sections
      Spree::HomeSection.all
    end

    def text_size_by_type(home_section, index)
      if home_section.main_banner?
        "1440 x 600"
      elsif home_section.banner_2?
        "540 x 350"
      elsif home_section.banner_3?
        index == 2 ? "540 x 800" : "540 x 388"
      end
    end

    def text_image_configuration(banner_3, index)
      return index + 1 unless banner_3
      index != 2 ? "imagen pequeña #{index + 1}" : "imagen grande"
    end

    def get_image_for(section, item, big = nil)
      if section.main_banner?
        if item.image.attached?
          main_app.url_for(item.image)
        else
          asset_path('homepage/main_banner.jpg')
        end
      elsif section.banner_2?
        if item.image.attached?
          main_app.url_for(item.image)
        else
          asset_path('homepage/promo_banner_left.jpg')
        end
      elsif section.banner_3?
        if item.image.attached?
          main_app.url_for(item.image)
        else
          big ? asset_path('homepage/big_category_banner.jpg') : asset_path('homepage/category_banner_upper.jpg')
        end
      end

    end

    private

    def get_homesection_partial(partial: home_section_partial, **partial_args)
      render(partial: partial, **partial_args)
    end

    def home_section_partial
      'spree/shared/home_sections'
    end
  end
end

# Author note:
# This helper and the homesection partial view, violates a few OOP principles
# I plan to change this when I have time to do so.
# Although I don't plan to change the public interface,
# the private interface will.
# for example, instead of calling render,
# a new Presenter or Service object would instead be called
