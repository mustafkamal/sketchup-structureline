require_relative '../contractor/contractor_company'
require_relative '../owner/itb'

module Mustafa
  module StructureLine
    module Environment
      module State
        class << self

          include Contractor
          include Owner

          attr_accessor :active_contractor,
                        :active_structure, :active_element_manager, :active_element, :active_component,
                        :selected_structure, :selected_element_manager, :selected_element, :selected_component

          def active_contractor
            @active_contractor ||= ContractorCompany.new(Itb.new)
          end
					
					def clear_contractor!
            @active_contractor = nil
					end

          def clear_selected_entity!
            @selected_structure = nil
            @selected_element_manager = nil
            @selected_element = nil
            @selected_component = nil
          end

          def user_selected_a_structure?
            @selected_structure
          end
        end
      end
    end
  end
end
