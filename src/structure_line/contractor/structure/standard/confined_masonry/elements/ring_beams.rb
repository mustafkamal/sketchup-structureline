module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          module ConfinedMasonry
            module Elements
              class RingBeams < ElementManager::SegmentElementManager::RcBeamManager

                def initialize(name, structure, width, height)
                  super
                end

                private

                def process_new_segment(segment)
                  register_rc_beam(start_node: segment.start_node,
                                   start_offset: get_start_offset,
                                   end_node: segment.end_node,
                                   end_offset: get_end_offset,
                                   style: get_element_style,
                                   group: nil,
                                   id: segment.id,
                                   width: @width,
                                   height: @height,
                                   presentation: get_element_presentation)
                  segment.attach_element(@name)
                end

                def get_start_offset
                  @structure.standard.ring_beam_offset
                end

                def get_end_offset
                  @structure.standard.ring_beam_offset
                end

              end
            end
          end
        end
      end

    end
  end
end