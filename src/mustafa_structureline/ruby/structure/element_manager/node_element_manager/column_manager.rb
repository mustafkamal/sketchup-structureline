require_relative '../base_element_manager'

module Mustafa
  module StructureLine
    module Structure
      module ElementManager
        module NodeElementManager
          class ColumnManager < BaseElementManager
            include NodeElementManager
            include Element::NodeElement
            def initialize(name, structure, size, height)
              super(name, structure)
              @size = size
              @height = height
              # Preview column ini hanya untuk ngebikin preview dari column yang akan dibuat. Di initialize disini karena
              # kalo di initialize di method draw nya itu bakal ngebikin sketchup jadi lemot banget.
              @preview_column = Column.new(manager: self,
                                           node: Node.new,
                                           offset: Geom::Vector3d.new,
                                           style: nil,
                                           group: nil,
                                           id: nil,
                                           direction: nil,
                                           size: @size,
                                           height: @height,
                                           presentation: nil)
            end

            def sync_with_segments
              return if not_ready_for_registration? # Gamau ngeregister apa2 kalo sebelum klikan kedua
              set_structure_direction if @nodes.size == 2
              super
            end

            def draw_preview(view, preview_point)
              handle_column_preview_drawing(view, preview_point)
            end

            private

            def not_ready_for_registration?
              @nodes.size < 2
            end

            def set_structure_direction
              first_node, second_node = @nodes
              @structure_direction = first_node.position.vector_to(second_node.position).normalize
            end

            def register_element_from_group(group, hash)
              register_column(node: get_node_from_json(hash['node']),
                              offset: get_3d_vector_from_json(hash['offset']),
                              style: hash['style'],
                              group: group,
                              id: hash['id'],
                              direction: get_3d_vector_from_json(hash['direction']),
                              size: hash['size'].mm,
                              height: hash['height'].mm,
                              presentation: hash['presentation'])
            end

            def register_column(node:, offset:, style:, group:, id:, direction:, size:, height:, presentation:)
              @elements[id] = Column.new(manager: self,
                                         node: node,
                                         offset: offset,
                                         style: style,
                                         group: group,
                                         id: id,
                                         direction: direction,
                                         size: size,
                                         height: height,
                                         presentation: presentation)
            end

            def handle_column_preview_drawing(view, preview_point)
              first_point = @nodes[0].position
              direction = @structure_direction || first_point.vector_to(preview_point).normalize
              return if direction.length == 0
              # Ngedraw column yang ada di pointer mouse
              draw_column_preview(view, preview_point, direction) if segment_break_is_on?
              # Kalo jumlah node nya baru 1 berarti node pertama itu belom disave karena structure direction nya belom
              # pasti, jadi kita mau bikin preview untuk kolom pertama nya
              draw_column_preview(view, first_point, direction) if @nodes.size == 1
            end

            def segment_break_is_on?
              @segments.segment_break
            end

            def draw_column_preview(view, preview_point, preview_direction)
              # Untuk preview itu harus
              @preview_column.node.position = preview_point
              @preview_column.direction = preview_direction
              @preview_column.update_drawing_points!
              @preview_column.draw(view)
            end

          end
        end
        end
    end
  end
end