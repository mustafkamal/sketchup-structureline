module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Auxiliary
          class BoundingBox

            def initialize(structure)
              @structure = structure
              @segments = @structure.segments
              @standard = @structure.standard
            end

            def get_bounding_box(preview_point = nil)
              bb = Geom::BoundingBox.new
              points = nodes_position + [preview_point]
              points.compact.each { |pt| bb.add(pt) }
              top = bb.max.offset(Z_AXIS, overall_height)
              bottom = bb.min.offset(Z_AXIS.reverse, overall_height)
              bb.add(top, bottom)
              bb
            end

            private

            def nodes_position
              @segments.nodes_position
            end

            def overall_height
              @standard.get_vertical_limit
            end

          end
        end
      end
    end
  end
end