module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Element
          module NodeElement
            class Column < BaseElement
              include NodeElement
              attr_accessor :direction, :size, :height, :style, :base_face, :offset
              attr_reader :node
              def initialize(manager:, node:, offset:, style:, group:, id:, direction:, size:, height:, presentation:)
                @manager = manager
                @node = node
                @offset = offset
                @style = style
                @group = group
                @id = id
                @direction = direction
                @size = size
                @height = height
                @presentation = presentation
                @type = ELEMENT_TYPE_COLUMN
                @components = {}
                @drawing_points = get_drawing_points
              end

              # Method untuk dapetin pts2 sebuah column
              def get_drawing_points
                return unless valid_geometry_input?
                tr = get_transformation_axis(position, @direction)
                half_of_column_side = @size/2

                local_pts = [
                  [-half_of_column_side, -half_of_column_side, 0],
                  [half_of_column_side, -half_of_column_side, 0],
                  [half_of_column_side, half_of_column_side, 0],
                  [-half_of_column_side, half_of_column_side, 0]
                ].map {|x,y,z| Geom::Point3d.new(x, y, z) }

                # Transform ke global koordinat
                base_pts = local_pts.map {|pt| pt.transform(tr) }
                top_pts = base_pts.map {|pt| pt.offset(Z_AXIS, @height) }

                base_pts + top_pts
              end

              # Method untuk ngegambar preview dari column
              #
              # @param view [Sketchup::View]
              def draw(view)
                # Preview styling
                view.line_width = 2
                view.drawing_color = 'CadetBlue'
                view.line_stipple = 'dot'

                # Draw base and top faces
                view.draw(GL_LINE_LOOP, @drawing_points[0..3]) # Base points
                view.draw(GL_LINE_LOOP, @drawing_points[4..7]) # Top points

                # Draw vertical edges
                4.times do |i|
                  view.draw(GL_LINES, @drawing_points[i], @drawing_points[i + 4])
                end
              end

              private

              def valid_geometry_input?
                position_established? &&
                  position.is_a?(Geom::Point3d) &&
                  @direction.is_a?(Geom::Vector3d) &&
                  @size.to_f > 0 &&
                  @height.to_f > 0
              end

              def serialize_properties
                {
                  node: @node.get_metadata,
                  offset: [@offset.x, @offset.y, @offset.z],
                  style: @style,
                  id: @id,
                  direction: [@direction.x, @direction.y, @direction.z],
                  size: @size.to_mm,
                  height: @height.to_mm,
                  presentation: @presentation
                }.to_json
              end
            end
          end
        end
      end

    end

  end
end