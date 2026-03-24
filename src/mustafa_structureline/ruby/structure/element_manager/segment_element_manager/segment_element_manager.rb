module Mustafa
  module StructureLine
    module Structure
      module ElementManager
        module SegmentElementManager

          def sync_with_segments
            sync_elements_to_segments
            delete_unwanted_element
          end

          def sync_with_skeleton
            self.elements.each do |element_id, element|
              element.each_node do |node|
                vertex = self.structure.skeleton[node.id]
                next unless vertex
                update_element_position(node, vertex, element)
              end
            end
          end

          def delete_unwanted_element
            self.elements.select! do |element_id, element|
              self.segments.any? {|segment| element_id == segment.id}
            end
          end

          private

          def sync_elements_to_segments
            self.segments.each do |segment|
              process_new_segment(segment) if need_to_process_new_segment?(segment)
            end
          end

          def need_to_process_new_segment?(segment)
            segment.not_yet_attached?(self.name)
          end

          def process_new_segment(node)
            # Memproses segment yang baru itu tergantung standard dari structure nya (child class ini)
            raise NotImplementedError, METHOD_ERROR_MESSAGE
          end

          def update_element_position(node, vertex, element)
            return if node.position == vertex.position
            node.position = vertex.position
            element.update_drawing_points!
          end

          def segment_element_preview_cannot_be_drawn?(preview_point)
            self.segments.last_segment.end_position.vector_to(preview_point).length == 0
          end

        end
      end
    end
  end
end