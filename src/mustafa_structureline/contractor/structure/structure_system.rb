require 'json'
require_relative 'auxiliary/skeleton'
require_relative 'auxiliary/bounding_box'
require_relative 'auxiliary/temp_edge'
require_relative 'element_builders/segment_manager'
require_relative 'standard/catalog'

module Mustafa
  module StructureLine
    module Contractor
      module Structure
        class StructureSystem
          include Utils::Constants
          include Auxiliary
          include ElementBuilders
          include Standard

          extend Forwardable

          def_delegators :@segments, :not_ready_to_draw?
          def_delegators :@standard, :establish_groups, :each_element, :each_element_manager, :should_draw_preview?,
                         :get_element_style, :get_element_presentation, :[]
          def_delegators :@temp_edge, :create_temp_edge, :delete_temp_edges
          def_delegators :@bounding_box, :get_bounding_box
          def_delegators :@skeleton, :create_skeleton, :delete_skeleton

          attr_accessor :type, :style, :presentation
          attr_reader :segments, :entities, :skeleton, :standard, :instance_path

          def initialize(type, style, presentation, group = nil, segments = nil)
            @type = type
            @style = style
            @presentation = presentation
            initialize_objects(group, segments)
            establish_standard
            establish_element_managers
            establish_auxiliary_objects
          end

          def process_new_point(new_point)
            return if same_point_twice?(new_point)
            update_segments(new_point)
            sync_elements_with_segments
          end

          def process_user_input(key)
            check_user_input_on_segment(key)
            check_user_input_on_standard(key)
          end

          def save_attributes
            save_structure_attributes
            save_segment_attributes
          end

          def sync_with_skeleton
            sync_segments_with_skeleton
            sync_elements_with_skeleton
          end

          private

          def initialize_objects(group, segments)
            handle_segments_object(segments)
            handle_group_object(group)
          end

          def handle_segments_object(segments)
            @segments = SegmentManager.new(self)
            @segments.load_segments(segments) if segments
          end

          def handle_group_object(group)
            @group = group || Sketchup.active_model.entities.add_group
            @entities = @group.entities
            @instance_path = Sketchup::InstancePath.new([@group])
            @group.set_attribute(DICT_NAME, DICT_KEY_TYPE, DICT_VALUE_STRUCTURE) unless group
          end

          def establish_standard
            @standard = Standard::Catalog.create_standard(self)
          end

          def establish_element_managers
            @element_managers = @standard.element_managers
          end

          def establish_auxiliary_objects
            @temp_edge = TempEdge.new(self)
            @bounding_box = BoundingBox.new(self)
            @skeleton = Skeleton.new(self)
          end

          def check_user_input_on_segment(key)
            @segments.toggle_segment_break if [87, 49].include?(key) # User nya mencet huruf 'w' di keyboard
          end

          def check_user_input_on_standard(key)
            @standard.process_user_input(key)
          end

          def same_point_twice?(new_node)
            @segments.same_point_twice?(new_node)
          end

          def update_segments(new_point)
            @segments.process_new_point(new_point)
          end

          def sync_elements_with_segments
            @element_managers.each_value do |element_manager|
              element_manager.sync_with_segments
            end
          end

          def sync_segments_with_skeleton
            @segments.sync_with_skeleton
          end

          def sync_elements_with_skeleton
            @element_managers.each_value do |element_manager|
              element_manager.sync_with_skeleton
            end
          end

          def save_structure_attributes
						@group.set_attribute(DICT_NAME, DICT_KEY_TYPE, DICT_VALUE_STRUCTURE)
            @group.set_attribute(DICT_NAME, DICT_KEY_STRUCTURE_TYPE, @type)
            @group.set_attribute(DICT_NAME, DICT_KEY_STRUCTURE_STYLE, @style)
            @group.set_attribute(DICT_NAME, DICT_KEY_STRUCTURE_PRESENTATION, @presentation)
          end

          def save_segment_attributes
            @group.set_attribute(DICT_NAME, DICT_KEY_SEGMENTS, @segments.serialize_segments)
          end

        end
      end
    end
  end
end