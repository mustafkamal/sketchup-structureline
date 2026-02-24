module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module ElementDesigner
            module Component
              class BaseComponent

                attr_reader :id, :presentation, :description, :type, :entities
                include Utils::Constants

                def establish_group
                  create_group
									save_attributes
                end

                def is_hidden?
                  @presentation == COMPONENT_PRESENTATION_HIDDEN
                end

                def each_face
                  return to_enum(:each) unless block_given?
                  @entities.each do |entity|
                    yield entity if entity.is_a?(Sketchup::Face)
                  end
                end

                def each_edge
                  return to_enum(:each) unless block_given?
                  @entities.each do |entity|
                    yield entity if entity.is_a?(Sketchup::Edge)
                  end
                end
								
								private
								
								def create_group
									@group = @element.entities.add_group
                  @entities = @group.entities
								end
								
								def save_attributes
									@group.set_attribute(DICT_NAME, DICT_KEY_TYPE, DICT_VALUE_COMPONENT)
		              @group.set_attribute(DICT_NAME, DICT_KEY_COMPONENT_TYPE, @type)
									@group.set_attribute(DICT_NAME, DICT_KEY_COMPONENT_ID, @id)
                  @group.set_attribute(DICT_NAME, DICT_KEY_COMPONENT_PRESENTATION, @presentation)

								end

              end
            end
          end
        end
      end
    end
  end
end