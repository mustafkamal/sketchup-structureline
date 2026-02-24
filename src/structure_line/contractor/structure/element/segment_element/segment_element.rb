module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Element
          module SegmentElement
            include ElementBuilders::SegmentCalculation

            def start_position
              self.start_node.position.offset(self.start_offset) || self.end_position
            end

            def start_position=(new_position)
              self.start_offset = self.start_position.vector_to(new_position)
            end

            def end_position
              self.end_node.position.offset(self.end_offset)
            end

            def end_position=(new_position)
              self.end_offset = self.end_position.vector_to(new_position)
            end

            def vector
              self.start_position.vector_to(end_position)
            end

            def length
              self.vector.length
            end

            def position_established?
              # Ada kemungkinan sebuah element itu dibentuk ketika posisi dia belum ditentukan
              self.start_node.position.is_a?(Geom::Point3d) && self.end_node.position.is_a?(Geom::Point3d)
            end

            def reverse_direction!
              old_start_position = self.start_position
              self.start_position = self.end_position
              self.end_position = old_start_position

              old_start_offset = self.start_offset
              self.start_offset = self.end_offset
              self.end_offset = old_start_offset
            end

            def each_node
              return to_enum(:each) unless block_given?
              [self.start_node, self.end_node].each do |node|
                yield node
              end
            end

            def apply_miter_cut(node, u1, u2)
              # Method ini cuman bisa bekerja kalo node yang dikasih itu seakan2 sebagai end_node bagi current wall sama
              # adjacent wall (u1 & u2 nya sama2 menuju ke node)
              bisector = (u1 + u2).normalize!
              offset_dist = self.get_miter_offset(u1, u2)
              self.set_mitered_extrusion_points(node, bisector, offset_dist, get_turning_direction(u1, u2))
            end

            def get_turning_direction(u1, u2)
              cross = u1.cross(u2)
              if cross.z > 0
                :left   # counter-clockwise
              elsif cross.z < 0
                :right  # clockwise
              else
                :colinear
              end
            end

            def point_on_segment_adjustment(element)
              # Method ini berguna untuk mengadjust extrusion point ketika element ini berhenti ditengah2 element lain
              t1 = self.perpendicular_length/2
              t2 = element.perpendicular_length/2
              offset_dist = Math.sqrt(t1**2 + t2**2)

              if self.start_point_on_segment?(element)
                u1 = self.vector.normalize
                node_status = :start
              else
                u1 = self.vector.reverse.normalize
                node_status = :end
              end

              rotation_transform = Geom::Transformation.rotation(self.start_position, Z_AXIS, 270.degrees)
              u2 = u1.transform(rotation_transform)
              self.set_perpendicular_extrusion_points(node_status, offset_dist, u1, u2)
            end

            def point_on_point_adjustment(node_element)
              # Method ini berguna untuk mengadjust extrusion point ketika element ini berhenti di suatu point element
              t1 = self.perpendicular_length/2
              t2 = node_element.size/2
              offset_dist = Math.sqrt(t1**2 + t2**2)

              if node_element.node.position == self.start_node.position
                u1 = self.vector.normalize
                node_status = :start
              else
                u1 = self.vector.reverse.normalize
                node_status = :end
              end

              rotation_transform = Geom::Transformation.rotation(self.start_position, Z_AXIS, 270.degrees)
              u2 = u1.transform(rotation_transform)
              self.set_perpendicular_extrusion_points(node_status, offset_dist, u1, u2)
            end

            def perpendicular_vector(turning_direction)
              if turning_direction == :right
                rot_angle = 270.degrees
              elsif turning_direction == :left
                rot_angle = 90.degrees
              else
                nil
              end
              rotation_transform = Geom::Transformation.rotation(self.start_position, Z_AXIS, rot_angle)
              self.vector.transform(rotation_transform)
            end

          end
        end
      end
    end

  end
end