require_relative 'material/loader'
require_relative 'observer/loader'


module Mustafa
  module StructureLine
    module Environment
			module AppObserver
				extend self

				def onNewModel(model)
					load_materials(model)
					load_observers(model)
	      end
	
	      def onOpenModel(model)
					load_materials(model)
					load_observers(model)
	      end
	
	      def load_observers(model)
					Observer::Loader.activate(model)
				end

				def load_materials(model)
					Material::Loader.activate(model)
				end
	
	      def expectsStartupModelNotifications
	        true
	      end

			end
    end
  end
end