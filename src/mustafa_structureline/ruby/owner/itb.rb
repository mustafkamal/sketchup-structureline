require_relative '../utils/ls/json_processor'
module Mustafa
  module StructureLine
    module Owner
      class Itb
        include Utils::Constants
        include Utils::JsonProcessor
        include Contractor::Structure::ElementBuilders

        attr_accessor :structure_presentation
        attr_reader :structure_type, :structure_style, :structure_group, :structure_segments

        def initialize(group = nil)
          return establish_default_value unless group
          @structure_group = group
          establish_structure_type
          establish_structure_style
          establish_structure_presentation
          establish_structure_segments
        end

        private

        def establish_default_value
          # Default value until there is a UI
          @structure_type = STRUCTURE_TYPE_CONFINED_MASONRY
          @structure_style = STRUCTURE_STYLE_1
          @structure_presentation = STRUCTURE_PRESENTATION_FULL
        end

        def establish_structure_type
          @structure_type = @structure_group.get_attribute(DICT_NAME, DICT_KEY_STRUCTURE_TYPE)
        end

        def establish_structure_style
          @structure_style = @structure_group.get_attribute(DICT_NAME, DICT_KEY_STRUCTURE_STYLE)
        end

        def establish_structure_presentation
          @structure_presentation = @structure_group.get_attribute(DICT_NAME, DICT_KEY_STRUCTURE_PRESENTATION)
        end

        def establish_structure_segments
          @structure_segments = get_segment_hashes.map { |segment_hash| build_segment(segment_hash) }
        end

        def get_segment_hashes
          JSON.parse(@structure_group.get_attribute(DICT_NAME, DICT_KEY_SEGMENTS))
        end

        def build_segment(segment_hash)
          Segment.new(
            get_node_from_json(segment_hash['start_node']),
            get_node_from_json(segment_hash['end_node']),
            segment_hash['attached_elements'],
            segment_hash['segment_id']
          )
        end

      end
    end
  end
end