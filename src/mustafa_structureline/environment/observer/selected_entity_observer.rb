require_relative '../../contractor/contractor_company'
require_relative '../../owner/itb'
module Mustafa
  module StructureLine
    module Environment
      module Observer
        class SelectedEntityObserver < Sketchup::SelectionObserver

          include Utils::Constants
          include Contractor
          include Owner

          def onSelectionBulkChange(selection)
            return if selection_is_the_same?(selection)

            puts "onSelectionBulkChange: #{selection}"

            return clear_report if the_user_selected_multiple_entity?(selection)
            entity = selection.first
            entity_type = get_entity_type(entity)

            case entity_type
            when DICT_VALUE_STRUCTURE
              handle_structure_report(entity)
            when DICT_VALUE_ELEMENT_MANAGER
              handle_element_manager_report(entity)
            when DICT_VALUE_ELEMENT
              handle_element_report(entity)
            when DICT_VALUE_COMPONENT
              handle_component_report(entity)
            else
              clear_report
            end

            puts "sampe sini"
          end

          def onSelectionCleared(selection)
            puts "onSelectionCleared: #{selection}"
            @last_selection = nil
            clear_report
          end

          def clear_report!
            clear_report
          end

          private

          def selection_is_the_same?(selection)
            return true if @last_selection == selection.to_a
            @last_selection = selection.to_a
            false
          end

          def clear_report
            State.clear_selected_entity!
            State.clear_contractor!
          end

          def the_user_selected_multiple_entity?(selection)
            selection.length > 1
          end

          def get_entity_type(entity)
            entity.get_attribute(DICT_NAME, DICT_KEY_TYPE)
          end

          def handle_structure_report(entity)
            State.active_contractor = ContractorCompany.new(Itb.new(entity))
            State.selected_structure = State.active_contractor.structure
          end

          def handle_element_manager_report(entity)
            # If the user is able to select an element_manager group that means that they are inside a structure
            # group which means that Report has an active_structure
            element_manager_name = entity.get_attribute(DICT_NAME, DICT_KEY_ELEMENT_MANAGER_NAME)
            State.selected_element_manager = State.active_structure[element_manager_name]
          end

          def handle_element_report(entity)
            element_id = entity.get_attribute(DICT_NAME, DICT_KEY_ELEMENT_ID)
            State.selected_element = State.active_element_manager[element_id]
          end

          def handle_component_report(entity)
            component_id = entity.get_attribute(DICT_NAME, DICT_KEY_COMPONENT_ID)
            State.selected_component = State.active_element[component_id]
          end

        end
      end
    end
  end
end