module Mustafa
  module StructureLine
    module Environment
      module Observer
        module Loader
          extend self

          def activate(model)
            # model.add_observer(ActiveEntityObserver.new)
            # model.selection.add_observer(SelectedEntityObserver.new)
          end

        end
      end
    end
  end
end