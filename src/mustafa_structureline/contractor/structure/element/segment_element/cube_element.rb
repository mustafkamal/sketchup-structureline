require_relative '../element'

module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Element
          module SegmentElement
            module CubeElement

              include Element

              def get_drawing_points
                return unless valid_geometry_input?
                tr = get_transformation_axis(start_position, vector)
                length = vector.length
                half_of_perpendicular_length = self.perpendicular_length/2

                # Titik2 di lokal koordinat
                local_pts = [
                  [0, half_of_perpendicular_length, 0],
                  [length, half_of_perpendicular_length, 0],
                  [length, -half_of_perpendicular_length, 0],
                  [0, -half_of_perpendicular_length, 0]
                ].map {|x,y,z| Geom::Point3d.new(x, y, z) }

                # Transform ke global koordinat
                base_pts = local_pts.map {|pt| pt.transform(tr) }
                top_pts = base_pts.map {|pt| pt.offset(Z_AXIS, self.height) }

                base_pts + top_pts
              end

              def valid_geometry_input?
                position_established? &&
                  self.start_position.is_a?(Geom::Point3d) &&
                  self.end_position.is_a?(Geom::Point3d) &&
                  self.perpendicular_length.to_f > 0 &&
                  self.height.to_f > 0 &&
                  self.length.to_f != 0
              end

              def draw_cube(view)
                # Draw base and top faces
                view.draw(GL_LINE_LOOP, self.drawing_points[0..3]) # Base points
                view.draw(GL_LINE_LOOP, self.drawing_points[4..7]) # Top points

                # Draw vertical edges
                4.times do |i|
                  view.draw(GL_LINES, self.drawing_points[i], self.drawing_points[i + 4])
                end
              end

              def get_miter_offset(u1, u2)
                angle = u1.angle_between(u2)
                offset_dist = (self.perpendicular_length/2) / Math.sin(angle / 2.0)
                offset_dist
              end

              def set_mitered_extrusion_points(node, bisector, offset_dist, turning_direction)
                adj_node_pos = node.position.offset(self.start_offset)
                if adj_node_pos == start_position
                  if turning_direction == :left
                    self.extrusion_points[0] = adj_node_pos.offset(bisector, offset_dist)
                    self.extrusion_points[3] = adj_node_pos.offset(bisector.reverse, offset_dist)
                  else
                    self.extrusion_points[0] = adj_node_pos.offset(bisector.reverse, offset_dist)
                    self.extrusion_points[3] = adj_node_pos.offset(bisector, offset_dist)
                  end
                else
                  if turning_direction == :left
                    self.extrusion_points[1] = adj_node_pos.offset(bisector.reverse, offset_dist)
                    self.extrusion_points[2] = adj_node_pos.offset(bisector, offset_dist)
                  else
                    self.extrusion_points[1] = adj_node_pos.offset(bisector, offset_dist)
                    self.extrusion_points[2] = adj_node_pos.offset(bisector.reverse, offset_dist)
                  end
                end
              end

              def set_perpendicular_extrusion_points(node_status, offset_dist, u1, u2)
                offset_direction_1 = (u1 + u2).normalize
                offset_direction_2 = (u1 - u2).normalize
                if node_status == :start
                  self.extrusion_points[0] = start_position.offset(offset_direction_1, offset_dist)
                  self.extrusion_points[3] = start_position.offset(offset_direction_2, offset_dist)
                else
                  self.extrusion_points[2] = end_position.offset(offset_direction_1, offset_dist)
                  self.extrusion_points[1] = end_position.offset(offset_direction_2, offset_dist)
                end
              end

            end
          end
        end
      end
    end
  end
end