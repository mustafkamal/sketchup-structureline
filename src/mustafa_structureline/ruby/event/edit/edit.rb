module Mustafa
  module StructureLine
    module Event
      module Edit
        extend self

        def activate(model, itb)
          @eo = Organizer.new(model, itb)
          @overlay = EditOverlay.new
          @observer = EditObserver.new(self)
          handle_activation_event
        end

        def deactivate
          # This will be triggered by the observer
          handle_deactivation_event
          #@eo.release_contractor
        end

        private

        def handle_activation_event
          @eo.enter_structure_group
          @eo.teardown_structure
          @eo.create_skeleton
          @eo.setup_overlay(@overlay)
          @eo.setup_observer(@observer)
        end

        def handle_deactivation_event
          @eo.remove_overlay(@overlay)
          @eo.remove_observer(@observer)
          @eo.delete_skeleton
          @eo.begin_construction
        end

      end
    end

  end
end



