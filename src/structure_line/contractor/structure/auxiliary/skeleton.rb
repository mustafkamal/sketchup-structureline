require_relative '../../../utils/constants'

module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Auxiliary
          class Skeleton
            include Utils

            attr_accessor :edges

            def initialize(structure)
              @structure = structure
              @edges = []
              @skeleton_lookup = {}
            end

            def create_skeleton
              create_edges_3d_model
              create_egges_array
              create_lookup_table
            end

            def delete_skeleton
              @structure.entities.erase_entities(@edges)
            end

            def each
              return to_enum(:each) unless block_given?
              @edges.each do |edge|
                yield edge
              end
            end

            def [](key)
              @skeleton_lookup[key]
            end

            private

            def create_edges_3d_model
              @structure.segments.each_with_object([]) do |segment, edges|
                @structure.entities.add_edges(segment.start_position, segment.end_position).first
              end
            end

            def create_egges_array
              # Ada kemungkinan kalo kita udah ngebikin edges sesuai segment, sketchup bakal ngebikin edges yang ga
              # kedetect (e.g kalo ada segment break yang intersect sebuah segment). Jadi kita mau bikin edges array nya
              # setelah semua segment udah di-loop. Jelek nya adalah kita mengasumsi semua entities yang ada di dalam
              # @structure itu isi nya cuman edges2 yang dibikin sama skeleton, ga ada edges yang lain.
              # TODO find a better way to get the skeleton edges array
              @structure.entities.each do |entity|
                @edges << entity if entity.is_a?(Sketchup::Edge)
              end
            end

            def create_lookup_table
              @edges.each do |edge|
                @structure.segments.each do |segment|
                  relation = LineRelation::relation(edge.start.position, edge.end.position, segment.start_position, segment.end_position)
                  case relation
                  when LineRelation::IDENTICAL
                    register_to_lookup_table(segment, edge)
                    #break
                  when LineRelation::COLINEAR_COVER_PARTIAL
                    # Kemungkinan kena segment break disini
                    handle_segment_break_registration(segment, edge)
                  when LineRelation::COLINEAR_RELATIONSHIP_NOT_FOUND
                    handle_segment_break_registration(segment, edge)
                  else
                    next
                  end
                end
              end
            end

            def register_to_lookup_table(segment, edge)
              @skeleton_lookup[segment.start_node.id] = edge.start
              @skeleton_lookup[segment.end_node.id] = edge.end
            end

            def handle_segment_break_registration(segment, edge)
              [segment.start_node, segment.end_node].each do |segment_node|
                [edge.start, edge.end].each do |vertex|
                  if segment_node.position == vertex.position
                    @skeleton_lookup[segment_node.id] = vertex
                    return
                  end
                end
              end
            end

          end
        end
      end

    end

  end
end