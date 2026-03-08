module Mustafa
  module StructureLine
    module Event
      module Edit
        class EditObserver < Sketchup::ModelObserver
          def initialize(event)
            @event = event
          end

          def onActivePathChanged(model)
						# We want the edit event to be over if the user exit the structure instance
						# active_path is nil when all instances are closed
            @event.deactivate unless model.active_path
          end
        end
      end
    end
  end
end