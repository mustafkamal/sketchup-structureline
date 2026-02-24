module Mustafa
  module StructureLine
    module Event
      module Create
        class CreateOverlay < Sketchup::Overlay

          include Environment

          attr_accessor :contractor

          OVERLAY_ID = 'StructureLineCreateOverlay'.freeze
          OVERLAY_NAME = 'Structure Line Create Overlay'.freeze

          def initialize
            super(OVERLAY_ID, OVERLAY_NAME)
          end

          def draw(view)
            @contractor.draw_structure_outline(view)
          end

          def getExtents
            @contractor.get_bounding_box
          end
        end
      end
    end
  end
end