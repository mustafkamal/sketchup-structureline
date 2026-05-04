require_relative '../organizer'
require_relative 'create_overlay'
require_relative 'create_structure_tool'

module Mustafa
  module StructureLine
    module Event
      class CreateEvent

        def initialize(model)
          @eo = Organizer.new(model)
          @active = true
          setup_overlay
          activate_create_structure_tool
        end

        # This method will be triggered by the tool
        def deactivate
          handle_deactivation_event if @active
          #@eo.release_contractor
        end
				
				def enable_overlay
					@overlay.enabled = true
				end
				
				def disable_overlay
					@overlay.enabled = false
				end

        private

        def setup_overlay
          # We want the overlay to be enabled only when the tool is suspended so that the structure outline can be
          # drawn even if the user activated another tool (e.g. when orbitin or panning).
          @overlay = CreateOverlay.new
          @eo.setup_overlay(@overlay, false)
        end

        def activate_create_structure_tool
          @eo.activate_tool(CreateStructureTool.new(self))
        end

        def handle_deactivation_event
          @active = false
          @eo.remove_overlay(@overlay)
          # This will activate the Sketchup's native Select tool. It will also trigger the #deactivate method of the
          # CreateStructure tool. The @active variable is to prevent an infinite loop
          @eo.activate_tool(nil)
        end

      end
    end

  end
end



