module Mustafa
  module StructureLine
    module Event
      module Styling
        extend self

        def activate(group, model, style)
          @event_organizer = EventOrganizer.new(group, model, self)
          @event_organizer.delete_structure_3d_model
          @event_organizer.structure.style = style
          @event_organizer.create_structure_3d_model
        end
      end
    end
  end
end