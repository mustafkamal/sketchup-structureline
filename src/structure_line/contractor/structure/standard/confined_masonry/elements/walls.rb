module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          module ConfinedMasonry
            module Elements
              class Walls < ElementManager::SegmentElementManager::WallManager

                def initialize(name, structure, thickness, height)
                  super
                end

                private

                def process_new_segment(segment)
                  register_wall(start_node: segment.start_node,
                                start_offset: Vector3d.new,
                                end_node: segment.end_node,
                                end_offset: Vector3d.new,
                                style: get_element_style,
                                group: nil,
                                id: segment.id,
                                thickness: @thickness,
                                height: @height,
                                presentation: get_element_presentation)
                  segment.attach_element(@name)
                end

              end
            end
          end
        end
      end
    end
  end
end