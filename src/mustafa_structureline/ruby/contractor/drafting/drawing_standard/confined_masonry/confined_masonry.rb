module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Drafting
          module DrawingStandard
            module ConfinedMasonry
              extend self

              include CollisionHandler

              def make_detail_drawing(structure)
                initialize_module_objects(structure)
                handle_collisions
              end

              private

              def initialize_module_objects(structure)
                @standard = structure.standard
                @walls = @standard.walls.elements
                @ring_beams = @standard.ring_beams.elements
                @columns = @standard.columns.elements
              end

              def handle_collisions
                handle_wall_to_wall_collisions
                handle_ring_beams_to_ring_beams_collisions
                handle_wall_to_column_collisions
                handle_ring_beams_to_column_collisions
              end

              def handle_wall_to_wall_collisions
                handle_segment_elements_end_to_end_collisions(@walls)
                handle_perpendicular_segment_elements_collisions(@walls)
              end

              def handle_ring_beams_to_ring_beams_collisions
                handle_segment_elements_end_to_end_collisions(@ring_beams)
                handle_perpendicular_segment_elements_collisions(@ring_beams)
              end

              def handle_wall_to_column_collisions
                handle_segment_element_end_to_node_element_collisions(@walls, @columns)
              end

              def handle_ring_beams_to_column_collisions
                handle_segment_element_end_to_node_element_collisions(@ring_beams, @columns)
              end

            end
          end
        end
      end
    end
  end
end