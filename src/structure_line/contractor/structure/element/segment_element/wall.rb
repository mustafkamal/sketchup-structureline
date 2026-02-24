module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Element
          module SegmentElement
            class Wall < BaseElement
              include SegmentElement
              include CubeElement

              attr_accessor :start_node, :start_offset, :end_node, :end_offset, :thickness, :height

              def initialize(manager:, start_node:, start_offset:, end_node:, end_offset:, style:, group:, id:,
                             thickness:, height:, presentation:)
                @manager = manager
                @start_node = start_node
                @start_offset = start_offset
                @end_node = end_node
                @end_offset = end_offset
                @style = style
                @group = group
                @id = id
                @thickness = thickness
                @height = height
                @presentation = presentation
                @type = ELEMENT_TYPE_WALL
                @components = {}
                @drawing_points = get_drawing_points
              end

              def draw(view)
                set_preview_style(view)
                draw_cube(view)
              end

              def perpendicular_length
                @thickness
              end

              private

              def set_preview_style(view)
                view.line_width = 2
                view.drawing_color = 'DarkOrange'
                view.line_stipple = 'dot'
              end

              def serialize_properties
                {
                  start_node: @start_node.get_metadata,
                  start_offset: [@start_offset.x, @start_offset.y, @start_offset.z],
                  end_node: @end_node.get_metadata,
                  end_offset: [@end_offset.x, @end_offset.y, @end_offset.z],
                  style: @style,
                  id: @id,
                  thickness: @thickness.to_mm,
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