require_relative '../../../../utils/ls/line_relation'

module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Drafting
          module CollisionHandler
            extend self
            include Utils::LineRelation

            def handle_segment_elements_end_to_end_collisions(elements)
              elements.each do |current_element_id, current_element|
                current_element.each_node do |node|
                  search_for_adjacent_element_and_apply_miter(elements, current_element, node) unless node.break?
                end
              end
            end

            def handle_perpendicular_segment_elements_collisions(elements)
              elements.each do |current_element_id, current_element|
                elements.each do |other_element_id, other_element|
                  next if current_element_id == other_element_id
                  next unless current_element.perpendicular_touch?(other_element)
                  current_element.point_on_segment_adjustment(other_element)
                end
              end
            end

            def handle_segment_element_end_to_node_element_collisions(segment_elements, node_elements)
              segment_elements.each_value do |segment_element|
                node_elements.each_value do |node_element|
                  segment_element.point_on_point_adjustment(node_element) if segment_and_node_elements_touched?(segment_element, node_element)
                end
              end
            end

            private

            def search_for_adjacent_element_and_apply_miter(elements, current_element, node)
              elements.each_value do |adjacent_element|
                next if segment_elements_do_not_touch?(current_element, adjacent_element)
                next if node_is_not_in_the_adjacent_element?(adjacent_element, node)
                u1 = get_u1(node, current_element)
                u2 = get_u2(node, adjacent_element)
                current_element.apply_miter_cut(node, u1, u2)
                return
              end
            end

            def segment_elements_do_not_touch?(current_element, adjacent_element)
              adjacent_element.id == current_element.id || !current_element.point_on_point?(adjacent_element)
            end

            def node_is_not_in_the_adjacent_element?(adjacent_element, node)
              adjacent_element.start_node.position != node.position && adjacent_element.end_node.position != node.position
            end

            def get_u1(node, current_element)
              vector = current_element.vector
              node == current_element.start_node ? vector.reverse.normalize : vector.normalize
            end

            def get_u2(node, adjacent_element)
              if adjacent_element.start_node.position == node.position
                adjacent_element.vector.reverse.normalize
              elsif adjacent_element.end_node.position == node.position
                adjacent_element.vector.normalize
              end
            end

            def segment_and_node_elements_touched?(segment_element, node_element)
              # Kita evaluasi pake node dulu biar node element yang ada offset nya tetep kebaca
              segment_element.start_node.position == node_element.node.position ||
                segment_element.end_node.position == node_element.node.position
            end

          end
        end
      end
    end
  end
end