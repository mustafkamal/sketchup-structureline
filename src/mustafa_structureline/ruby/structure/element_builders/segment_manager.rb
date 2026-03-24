module Mustafa
  module StructureLine
    module Structure
      module ElementBuilders
        class SegmentManager
          include Enumerable
          include Utils::Constants
          attr_accessor :segments
          attr_reader :last_segment, :segment_break, :last_registered_segment, :nodes, :nodes_position

          RECALCULATION_HANDLERS = {
            colinear_cover_extend: :handle_colinear_cover_extend_recalculation,
            colinear_cover_partial: :handle_colinear_cover_partial_recalculation,
            colinear_cover: :handle_colinear_cover_recalculation,
            colinear_containment: :handle_colinear_containment_recalculation,
            colinear_overlap: :handle_colinear_overlap_recalculation,
            colinear_overlap_extend: :handle_colinear_overlap_extend_recalculation
          }.freeze

          def initialize(structure)
            establish_segment_objects
            establish_structure_objects(structure)
          end

          def load_segments(segments)
            @segments = segments
            @nodes_position = get_node_positions
          end

          def same_point_twice?(new_point)
            !@nodes.empty? && @nodes.last.position == new_point
          end

          def process_new_point(new_point)
            establish_new_node(new_point)
            update_last_segment
            handle_recalculation unless not_ready_for_recalculation?
            register_segment(duplicate_last_segment) unless dont_register?
            restore_last_segment_registration_flag
          end

          def toggle_segment_break
            @segment_break = !@segment_break
          end

          def not_ready_to_draw?
            @nodes.empty?
          end

          def each
            return to_enum(:each) unless block_given?
            @segments.each do |segment|
              yield segment
            end
          end

          def size
            @segments.size
          end

          def [](index)
            @segments[index]
          end

          def sync_with_skeleton
            @segments.each do |segment|
              update_node_position(segment.start_node)
              update_node_position(segment.end_node)
            end
          end

          def serialize_segments
            @segments.map do |segment|
              segment.get_metadata
            end.to_json
          end

          private

          def establish_segment_objects
            @segments = []
            @last_segment = Segment.new(Node.new, Node.new)
            @segment_break = true
            @last_segment_registration_flag = true
            @nodes = []
            @nodes_position = []
          end

          def establish_structure_objects(structure)
            @structure = structure
            @standard = @structure.standard
            @skeleton = @structure.skeleton
          end

          def establish_new_node(new_point)
            @last_node = Node.new(new_point, get_node_elements_from_standard, @segment_break)
            @nodes << @last_node
            @nodes_position << new_point
          end

          def get_node_elements_from_standard
            get_elements_to_be_attached(@structure.standard.node_elements_attachment_table)
          end

          def get_elements_to_be_attached(attachment_table)
            elements = {}
            attachment_table.each do |name, flag|
              elements[name] = false if flag
            end
            elements
          end

          def update_last_segment
            @last_segment = Segment.new(@last_segment.end_node.clone, @last_node.clone, get_segment_elements_from_standard)
            # @last_segment.start_node = @last_segment.end_node.clone
            # @last_segment.end_node = @last_node.clone
            # @last_segment.unattach_all_elements!
          end

          def not_ready_for_recalculation?
            @last_segment.invalid? || @segments.size < 1
          end

          def handle_recalculation
            handle_colinear_recalculation
            handle_intersection_recalculation
          end

          def handle_colinear_recalculation
            # Kalo ada exact_match berarti udah pasti tidak ada recalculation, kita bisa exit early
            exact_match = @segments.find { |segment| @last_segment.identical?(segment) }
            return handle_exact_same_segment(exact_match) if exact_match
            colinear_segments = @segments.select { |segment| need_recalculation?(segment) }
            handle_colinear_segments(colinear_segments) unless colinear_segments.empty?
          end

          def need_recalculation?(segment)
            return false unless @last_segment.colinear?(segment)
            # Exclude colinear disjoint sama colinear touch dari recalculation
            ![:colinear_disjoint, :colinear_touch].include?(@last_segment.get_colinear_type(segment))
          end

          def handle_exact_same_segment(segment)
            @segments.delete(segment)
          end

          def handle_colinear_segments(colinear_segments)
            sort_colinear_segments(colinear_segments)
            recalculate_colinear_segments(colinear_segments)
          end

          def sort_colinear_segments(colinear_segments)
            colinear_segments.sort_by! do |segment|
              handle_direction_reversal(segment) unless @last_segment.same_direction?(segment)
              point_distance = @last_segment.start_position.distance(segment.start_position)
              point_distance
            end
          end

          def handle_direction_reversal(segment)
            segment.reverse_direction!
            # Hapus semua attached elements biar pas syncing si manager nya bikin component baru dengan arah yang update
            segment.unattach_all_elements!
          end

          def recalculate_colinear_segments(colinear_segments)
            colinear_segments.each do |segment|
              type = @last_segment.get_colinear_type(segment)
              method = RECALCULATION_HANDLERS[type]
              send(method, segment) if method
            end
          end

          def handle_colinear_cover_extend_recalculation(segment)
            @last_segment.start_node = segment.end_node
          end

          def handle_colinear_cover_partial_recalculation(segment)
            return @last_segment_registration_flag = false unless segment_break?
            segment.unattach_all_elements!
            register_segment(Segment.new(@last_segment.end_node, segment.end_node, segment.attached_elements))
            @segments.delete(segment)
          end

          def handle_colinear_cover_recalculation(segment)
            register_segment(Segment.new(@last_segment.start_node, segment.start_node, get_segment_elements_from_standard))
            @last_segment.start_node = segment.start_node
            @segments.delete(segment)
          end

          def handle_colinear_containment_recalculation(segment)
            register_segment(Segment.new(@last_segment.start_node, segment.start_node, get_segment_elements_from_standard))
            @last_segment.start_node = segment.end_node
          end

          def handle_colinear_overlap_recalculation(segment)
            register_segment(Segment.new(@last_segment.start_node, segment.start_node, get_segment_elements_from_standard))
            return @last_segment_registration_flag = false unless segment_break?
            segment.unattach_all_elements!
            register_segment(Segment.new(@last_segment.end_node, segment.end_node, segment.attached_elements))
            @last_segment.start_node = segment.start_node
            @segments.delete(segment)
          end

          def handle_colinear_overlap_extend_recalculation(segment)
            return @last_segment_registration_flag = false unless segment_break?
            segment.unattach_all_elements!
            register_segment(Segment.new(segment.start_node, @last_segment.start_node, segment.attached_elements))
            register_segment(Segment.new(@last_segment.start_node, segment.end_node, segment.attached_elements))
            @segments.delete(segment)
          end

          def handle_intersection_recalculation
            handle_point_on_segment_recalculation(intersected_segment) if @segment_break
          end

          def intersected_segment
            @segments.find { |segment| @last_segment.end_point_on_segment?(segment) }
          end

          def handle_point_on_segment_recalculation(segment)
            return if segment.nil?
            segment.unattach_all_elements!
            register_segment(Segment.new(segment.start_node.clone,
                                         @last_segment.end_node.clone,
                                         segment.attached_elements.clone))
            register_segment(Segment.new(@last_segment.end_node.clone,
                                         segment.end_node.clone,
                                         segment.attached_elements.clone))
            @segments.delete(segment)
          end

          def get_segment_elements_from_standard
            get_elements_to_be_attached(@structure.standard.segment_elements_attachment_table)
          end

          def dont_register?
            !@last_segment_registration_flag || @last_segment.invalid?
          end

          def duplicate_last_segment
            @last_registered_segment = Segment.new(@last_segment.start_node, @last_segment.end_node,
                                                   @last_segment.attached_elements)
            @last_registered_segment.start_node.break = @last_segment.start_node.break
            @last_registered_segment.end_node.break = @last_segment.end_node.break
            @last_registered_segment
          end

          def segment_break?
            @segment_break
          end

          def restore_last_segment_registration_flag
            @last_segment_registration_flag = true
          end

          def register_segment(segment)
            @segments << segment
          end

          def update_node_position(segment_node)
            if segment_node.position != @structure.skeleton[segment_node.id].position
              segment_node.position = @structure.skeleton[segment_node.id].position
            end
          end

          def get_node_positions
            seen = {}
            @segments.each_with_object([]) do |segment, nodes|
              [segment.start_position, segment.end_position].each do |pt|
                key = "#{pt.x.to_f},#{pt.y.to_f},#{pt.z.to_f}"
                unless seen[key]
                  nodes << pt.clone
                  seen[key] = true
                end
              end
            end
          end

        end
      end
    end
  end
end