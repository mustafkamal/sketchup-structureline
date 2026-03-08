require 'securerandom'

module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module ElementBuilders
          class Node
            attr_accessor :position, :break
            attr_reader :attached_elements, :id

            def initialize(position = nil, attached_elements = {}, node_break = true, id = SecureRandom.uuid)
              @position = position
              @attached_elements = attached_elements
              @break = node_break
              @id = id
            end

            def overwrite_from(node)
              @position = node.position.clone
              @attached_elements = node.attached_elements.clone
              @break = node.break
              @id = node.id
            end

            def attach_element(element_name)
              @attached_elements[element_name] = true
            end

            def not_yet_attached?(element_name)
              @attached_elements[element_name] == false
            end

            def unattach_all_elements!
              @attached_elements.transform_values! { false }
            end

            def break?
              @break
            end

            def get_metadata
              {
                position: [@position.x.to_mm, @position.y.to_mm, @position.z.to_mm],
                attached_elements: @attached_elements,
                break: @break,
                node_id: @id
              }
            end
          end
        end
      end
    end


  end
end