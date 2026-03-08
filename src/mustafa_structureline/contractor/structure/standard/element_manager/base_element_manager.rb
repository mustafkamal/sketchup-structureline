require_relative '../../../../utils/json_processor'
module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          module ElementManager
            class BaseElementManager
              include Enumerable
              include Geom
              include ElementBuilders
              include Utils::Constants
              include Utils::JsonProcessor
              attr_accessor :nodes, :group, :structure, :elements, :preview_element
              attr_reader   :entities, :segments, :name

              def initialize(name, structure)
                @elements = {}
                @name = name
                @structure = structure
                @segments = @structure.segments
                @nodes = @segments.nodes
                # Ada kemungkinan structure yang ngeinitialize element manager ini itu udah ada group nya, kalo gitu
                # berarti kita harus initialize object2 element manager & element yang ada di dalem group structure nya
                initialize_element_manager_group
                create_element_objects
              end

              def establish_groups
                create_group
                save_attributes
              end

              def each
                return to_enum(:each) unless block_given?
                @elements.each_value do |element|
                  yield element
                end
              end

              def [](index)
                @elements[index]
              end

              def should_draw_preview?
                @structure.should_draw_preview?(@name)
              end

              def get_element_style
                @structure.get_element_style(@name)
              end

              def get_element_presentation
                @structure.get_element_presentation(@name)
              end

              def inspect
                "#<#{self.class}:#{object_id} name=#{@name}>"
              end

              private

              def initialize_element_manager_group
                @group = get_element_manager_group_from_structure || @structure.entities.add_group
              end

              def get_element_manager_group_from_structure
                @structure.entities.each do |entity|
                  return entity if entity_is_the_correct_element_manager_group?(entity)
                end
                nil
              end

              def entity_is_the_correct_element_manager_group?(entity)
                entity.is_a?(Sketchup::Group) && entity.get_attribute(DICT_NAME, DICT_KEY_ELEMENT_MANAGER_NAME) == @name
              end

              def create_element_objects
                @group.entities.each do |entity|
                  handle_element_registration_from_group(entity) if entity_is_an_element_group?(entity)
                end
              end

              def entity_is_an_element_group?(entity)
                # Bisa jadi user nya nambah2in group sendiri di dalem group element manager
                # Kita mau filter itu dengan ngecek dia ada attribute dari dictionary kita apa engga
                entity.is_a?(Sketchup::Group) && entity.get_attribute(DICT_NAME, DICT_KEY_TYPE)
              end

              def handle_element_registration_from_group(group)
                hash = get_element_hash(group)
                register_element_from_group(group, hash)
              end

              def get_element_hash(group)
                JSON.parse(group.get_attribute(DICT_NAME, DICT_KEY_ELEMENT_PROPERTIES))
              end

              def create_group
                @group = @structure.entities.add_group
                @entities = @group.entities # Biar kalo element mau ngebikin group itu statement nya ga panjang
              end

              def save_attributes
								@group.set_attribute(DICT_NAME, DICT_KEY_TYPE, DICT_VALUE_ELEMENT_MANAGER)
                @group.set_attribute(DICT_NAME, DICT_KEY_ELEMENT_MANAGER_NAME, @name)
              end

            end
          end
        end
      end
    end
  end
end