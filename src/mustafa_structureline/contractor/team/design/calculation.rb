module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module Calculation

            def arc_points(center, normal, radius, start_angle, end_angle, segments, reference_dir)
              points = []

              # Ensure reference_dir is orthogonal to normal
              proj = normal.clone
              proj.length = reference_dir.dot(normal) / normal.dot(normal)
              reference_dir = (reference_dir - proj).normalize

              angle_step = (end_angle - start_angle) / segments.to_f

              (segments + 1).times do |i|
                theta = start_angle + i * angle_step
                tr = Geom::Transformation.rotation(center, normal, theta)
                radius_vector = reference_dir.transform(tr)
                points << center.offset(radius_vector, radius)
              end

              points
            end

            def perpendicular_vector(v)
              arbitrary = if v.parallel?(Geom::Vector3d.new(1,0,0))
                            Geom::Vector3d.new(0,1,0)
                          else
                            Geom::Vector3d.new(1,0,0)
                          end
              perp = v.cross(arbitrary)
              perp.normalize!
              perp
            end


          end
        end
      end
    end
  end
end