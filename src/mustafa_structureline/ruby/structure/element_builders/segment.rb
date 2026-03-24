require 'securerandom'
require_relative '../../../utils/ls/line_relation'
require_relative '../element_builders/rb'

module Mustafa
  module StructureLine
    module Structure
      module ElementBuilders
        class Segment
          include Utils::LineRelation
          include SegmentCalculation
          attr_accessor :start_node, :end_node
          attr_reader :vector, :attached_elements, :id

          def initialize(start_node, end_node, attached_elements = {}, id = SecureRandom.uuid)
            @start_node = start_node
            @end_node = end_node
            @attached_elements = attached_elements
            @id = id
          end

          def start_position=(value)
            @start_node.position = value
          end

          def start_position
            @start_node.position || @end_node.position
          end

          def end_position=(value)
            @end_node.position = value
          end

          def end_position
            @end_node.position
          end

          def vector
            start_position.vector_to(end_position) || Geom::Vector3d.new(0,0,0)
          end

          def invalid?
            start_position == end_position
          end

          def reverse_direction!
            old_start_node = @start_node.clone
            @start_node.overwrite_from(@end_node)
            @end_node.overwrite_from(old_start_node)
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

          def same_direction?(segment)
            vector.samedirection?(segment.vector)
          end

          def parallel?(segment)
            vector.parallel?(segment.vector)
          end

          def perpendicular?(segment)
            vector.dot(segment.vector).abs < 1e-6
          end

          def get_metadata
            {
              start_node: @start_node.get_metadata,
              end_node: @end_node.get_metadata,
              attached_elements: @attached_elements,
              segment_id: @id
            }
          end
        end
      end
    end
  end
end