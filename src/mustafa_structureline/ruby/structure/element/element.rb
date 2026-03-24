module Mustafa
  module StructureLine
    module Structure
      module Element
        def get_transformation_axis(node, vector)
          # Local axes
          x_axis = vector.normalize
          z_axis = Z_AXIS
          y_axis = z_axis.cross(x_axis).normalize # Cross product (perpendicular to the plane)

          # Transformation axis
          tr  = Geom::Transformation.axes(node, x_axis, y_axis, z_axis)
          tr
        end

      end
    end
  end
end