module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          module ElementManager
            module SegmentElementManager
              class WallManager < BaseElementManager
                include SegmentElementManager
                include Element::SegmentElement

                def initialize(name, standard, thickness, height)
                  super(name, standard)
                  @thickness = thickness
                  @height = height
                  @preview_element = Wall.new(manager: self,
                                              start_node: Node.new,
                                              start_offset: Vector3d.new,
                                              end_node: Node.new,
                                              end_offset: Vector3d.new,
                                              style: nil,
                                              group: nil,
                                              id: nil,
                                              thickness: @thickness,
                                              height: @height,
                                              presentation: nil)
                end

                def draw_preview(view, preview_point)
                  return if segment_element_preview_cannot_be_drawn?(preview_point)
                  @preview_element.start_node.position = self.segments.last_segment.end_position
                  @preview_element.end_node.position = preview_point
                  @preview_element.update_drawing_points!
                  @preview_element.draw(view)
                end

                private

                def register_element_from_group(group, hash)
                  register_wall(start_node: get_node_from_json(hash['start_node']),
                                start_offset: get_3d_vector_from_json(hash['start_offset']),
                                end_node: get_node_from_json(hash['end_node']),
                                end_offset: get_3d_vector_from_json(hash['end_offset']),
                                style: hash['style'],
                                group: group,
                                id: hash['id'],
                                thickness: hash['thickness'].mm,
                                height: hash['height'].mm,
                                presentation: hash['presentation']
                  )

                end

                def register_wall(start_node:, start_offset:, end_node:, end_offset:,
                                  style:, group:, id:, thickness:, height:, presentation:)
                  @elements[id] = Wall.new(manager: self,
                                           start_node: start_node,
                                           start_offset: start_offset,
                                           end_node: end_node,
                                           end_offset: end_offset,
                                           style: style,
                                           group: group,
                                           id: id,
                                           thickness: thickness,
                                           height: height,
                                           presentation: presentation
                  )
                end

              end
            end
          end
        end
      end
    end
  end
end