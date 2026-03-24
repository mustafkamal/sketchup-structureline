require_relative '../owner/itb'
module Mustafa
  module StructureLine
    module Event
      class Organizer
        include Contractor
        include Owner
        include Utils::Constants
        include Utils::JsonProcessor

        extend Forwardable

        def_delegators  :@contractor, :create_skeleton, :delete_skeleton, :begin_construction, :teardown_structure
        attr_reader :contractor

        def initialize(model)
          @model = model
          hire_contractor
        end

        def enter_structure_group
          @model.active_path = @contractor.instance_path
        end

        def setup_observer(observer)
          @model.add_observer(observer)
        end

        def remove_observer(observer)
          @model.remove_observer(observer)
        end

        def setup_overlay(overlay, enable_status = true)
          overlay.contractor = @contractor
          @model.overlays.add(overlay)
          overlay.enabled = enable_status
        end

        def remove_overlay(overlay)
          @model.overlays.remove(overlay)
        end

        def activate_tool(tool = nil)
          tool.contractor = @contractor if tool
          @model.select_tool(tool)
        end
				
				def release_contractor
          #Report.release_contractor!
				end

        private

        def hire_contractor
          @contractor = ContractorCompany.new(@itb)
        end

      end
    end
  end
end