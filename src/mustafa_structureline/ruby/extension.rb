require_relative 'environment/app_observer'
require_relative 'ui/menu'

module Mustafa
  module StructureLine

    class Extension
      VERSION   = '1.0.0-dev' ## /!\ Auto-generated line, do not edit ##
      IS_DEV = VERSION.end_with?('-dev')

      include Environment
      include UserInterface

      def setup
        # This method will only be triggered when SketchUp load the extension for the very first time
        setup_ui
        setup_app_observer
        setup_contractor
      end

      def reload
        IS_DEV && (load('main.rb'); puts 'Extension is reloaded')
      end

      private

      def setup_ui
        Menu.setup
      end

      def setup_app_observer
        Sketchup.add_observer(AppObserver)
      end

      def setup_contractor
        CONTRACTOR = Contractor.new(self)
      end

    end

  end
end