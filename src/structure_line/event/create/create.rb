module Mustafa
  module StructureLine
    module Event
      module Create
        extend self

        def activate(model, itb)
          @eo = Organizer.new(model, itb)
          @active = true
          setup_overlay
          activate_create_structure_tool
        end

        # This will be triggered by the tool
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
          # drawn even if the user activated another tool.
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



