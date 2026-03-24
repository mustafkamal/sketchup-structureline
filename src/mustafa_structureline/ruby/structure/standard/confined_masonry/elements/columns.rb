require_relative '../../../element_manager/node_element_manager/column_manager'

module Mustafa
  module StructureLine
    module Structure
      module Standard
        module ConfinedMasonry
          module Elements
            class Columns < ElementManager::NodeElementManager::ColumnManager

              def initialize(name, structure, size, height)
                super
              end

              private

              def process_new_node(node)
                register_column(node: node,
                                offset: Vector3d.new,
                                style: get_element_style,
                                group: nil,
                                id: node.id,
                                direction: @structure_direction,
                                size: @size,
                                height: @height,
                                presentation: get_element_presentation)
                node.attach_element(@name)
              end

            end
          end
        end
      end
      end
  end
end