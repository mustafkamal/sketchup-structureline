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
	
				#RUN ONCE AT STARTUP:
	      unless defined?(@loaded)
	        # Attach this module as an AppObserver object:
	        Sketchup.add_observer(self)
	        @loaded = true
	      end
			end
    end
  end
end