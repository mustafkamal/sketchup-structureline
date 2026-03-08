module Mustafa
  module StructureLine
    module Event
      module Edit
        class EditOverlay < Sketchup::Overlay

          include Environment

          attr_accessor :contractor

          OVERLAY_ID = 'StructureLineEditOverlay'.freeze
          OVERLAY_NAME = 'Structure line Edit Overlay'.freeze

          def initialize
            super(OVERLAY_ID, OVERLAY_NAME)
            @contractor = State.active_contractor
          end

          def draw(view)
            @contractor.sync_with_skeleton
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