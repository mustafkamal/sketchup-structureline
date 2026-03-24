module Mustafa
  module StructureLine
    module Structure
      module Element
        class BaseElement
          include Utils::Constants
          attr_accessor :group, :components, :components
          attr_reader :entities, :id, :type, :drawing_points, :extrusion_face, :style, :presentation

          METHOD_ERROR_MESSAGE = "{self.class} must implement the #{__method__} method"

          def get_drawing_points
            raise NotImplementedError, METHOD_ERROR_MESSAGE
          end

          def draw
            raise NotImplementedError, METHOD_ERROR_MESSAGE
          end

          def establish_group
            create_group
            save_attributes
          end

          def transformation
            @group.transformation
          end

          def update_drawing_points!
            @drawing_points = get_drawing_points
          end

          def extrusion_points
            # Extrusion points itu adalah point2 yang bakal ngebentuk face yang akan di extrude waktu ngebikin 3d
            # model dari component nya. Extrusion face ini bakal dibikin ketika component nya masuk ke collision handler.
            # Untuk component yang ga masuk ke collision handler, berarti drawing_points nya dianggap sebagai extrusion face nya.
            @extrusion_points ||= @drawing_points.dup
          end

          def extrusion_points=(value)
            @extrusion_points = value
          end

          def [](component_id)
            @components[component_id]
          end

          def each_component
            return to_enum(:each) unless block_given?
            @components.each_value do |component|
              yield component
            end
          end

          def simple_presentation?
            @presentation == ELEMENT_PRESENTATION_SIMPLE
          end

          def delete_3d_model
            @group.entities.erase_entities(@group.entities.to_a)
          end

          def inspect
            "#<#{self.class}:#{object_id} name=#{@name}>"
          end

          private

          def create_group
            @group = @manager.entities.add_group
            @entities  = @group.entities
          end

          def save_attributes
            save_element_type_attribute
            save_element_properties_attribute
          end

          def save_element_type_attribute
            @group.set_attribute(DICT_NAME, DICT_KEY_TYPE, DICT_VALUE_ELEMENT)
            @group.set_attribute(DICT_NAME, DICT_KEY_ELEMENT_TYPE, @type)
            @group.set_attribute(DICT_NAME, DICT_KEY_ELEMENT_ID, @id)
          end

          def save_element_properties_attribute
            @group.set_attribute(DICT_NAME, DICT_KEY_ELEMENT_PROPERTIES, serialize_properties)
          end

          def serialize_properties
            raise NotImplementedError, METHOD_ERROR_MESSAGE
          end

        end
      end
    end
  end
end