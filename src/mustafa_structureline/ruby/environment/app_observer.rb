require_relative 'observer/loader'
require_relative 'material/loader'

module Mustafa
  module StructureLine
    module Environment
			module AppObserver
				extend self

				def onNewModel(model)
					load_observer(model)
					load_materials(model)
	      end
	
	      def onOpenModel(model)
					load_observer(model)
	      end
	
	      def load_observer(model)
					Observer::Loader.activate(model)
				end

				def load_materials(model)
					Material::Loader.activate(model)
				end
	
	      def expectsStartupModelNotifications
	        true
	      end
	
	      def onQuit
	        # execute onQuit tasks
	      end

			end
    end
  end
end