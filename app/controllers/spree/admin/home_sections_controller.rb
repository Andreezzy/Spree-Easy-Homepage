module Spree
  module Admin
	class HomeSectionsController < ResourceController
		def create
			#Spree core implementation update method
			invoke_callbacks(:create, :before)
			@object.attributes = permitted_resource_params
			if @object.save
				invoke_callbacks(:create, :after)
				flash[:success] = flash_message_for(@object, :successfully_created)
				respond_with(@object) do |format|
					#I changed this redirect
					format.html { redirect_to edit_admin_home_section_path(@object) }
					format.js   { render layout: false }
				end
			else
				invoke_callbacks(:create, :fails)
				respond_with(@object) do |format|
					format.html { render action: :new }
					format.js { render layout: false }
				end
			end
		end

		def edit
			@items = generate_items
			super
		end

		def update
			if params[:home_section][:home_section_items_attributes]
				params[:home_section][:home_section_items_attributes].each do |item|
					if Spree::HomeSectionItem.where(id: item[0]).any?
						value = Spree::HomeSectionItem.find(item[0])
						value.update(item[1].permit!)
					else
						item = Spree::HomeSectionItem.new(item[1].permit!)
						item.home_section_id = @home_section.id
						item.save!
					end
				end
				params[:home_section] = params[:home_section].except(:home_section_items_attributes)
			end

			#if params[:home_section][:images].present?
				#params[:home_section][:images].each do |image|
					#@home_section.images.attach(image)
				#end
				#params[:home_section] = params[:home_section].except(:images)
			#end

			#Spree core implementation update method
			invoke_callbacks(:update, :before)
			if @object.update(permitted_resource_params)
				invoke_callbacks(:update, :after)
				respond_with(@object) do |format|
					format.html do
						flash[:success] = flash_message_for(@object, :successfully_updated)
						#I changed this redirect
						redirect_to edit_admin_home_section_path(@object)
					end
					format.js { render layout: false }
				end
			else
				invoke_callbacks(:update, :fails)
				respond_with(@object) do |format|
					format.html { render action: :edit }
					format.js { render layout: false }
				end
			end
		end
		def destroy
			if params.has_key?("img")
				@image = ActiveStorage::Blob.find_signed(params[:img])
				@image.attachments.first.purge
				redirect_to edit_admin_home_section_path(@home_section)
			else
				super
			end
		end

		def generate_items
			ids = @home_section.items.pluck(:id)

			home_section_size_banner = @home_section.get_images_size_for_banner

			limit = home_section_size_banner - ids.size

			return @home_section.items.limit(home_section_size_banner) if limit < 0

			last_id = Spree::HomeSectionItem.any? ? Spree::HomeSectionItem.maximum(:id).next : 1

			values = (last_id...last_id + limit).to_a

			new_values = Array.new(values).map{|x| HomeSectionItem.new(id: x, home_section_id: @home_section.id)}
			@home_section.items + new_values
		end
	end
  end
end
