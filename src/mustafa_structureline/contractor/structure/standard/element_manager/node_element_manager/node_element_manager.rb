module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          module ElementManager
            module NodeElementManager

              def sync_with_segments
                sync_elements_to_nodes
                delete_unwanted_element
              end

              def sync_with_skeleton
                self.elements.each do |element_id, element|
                  vertex = self.structure.skeleton[element_id]
                  next unless vertex
                  update_element_position(element, vertex) if element.node.position != vertex.position
                end
              end

              private

              def sync_elements_to_nodes
                self.nodes.each do |node|
                  process_new_node(node) if need_to_process_new_node?(node)
                end
              end

              def process_new_node(node)
                # Memproses node yang baru itu tergantung standard dari structure nya (child class ini)
                raise NotImplementedError, METHOD_ERROR_MESSAGE
              end

              def need_to_process_new_node?(node)
                node.not_yet_attached?(self.name)
              end

              def delete_unwanted_element
                self.elements.select! do |element_id, element|
                  self.nodes.any? {|node| element_id == node.id}
                end
              end

              def update_element_position(element, vertex)
                element.node.position = vertex.position
                element.update_drawing_points!
              end
            end
          end
        end
      end
    end
  end
end