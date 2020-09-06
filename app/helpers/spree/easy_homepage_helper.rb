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
