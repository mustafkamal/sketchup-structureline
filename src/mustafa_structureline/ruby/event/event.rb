require_relative 'create/create_event'
require_relative 'edit/edit'

module Mustafa
  module StructureLine
    module Event

      def activate_create_event
        CreateEvent.new(Sketchup.active_model)
      end

    end
  end
end