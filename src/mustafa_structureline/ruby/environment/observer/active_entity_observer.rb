module Mustafa
  module StructureLine
    module Environment
			module Observer
				# An active entity refers to the entities the user has double-clicked on for editing.
				# For this extension we are only interested in the structure, element_manager, element, or component's group.
				# We want to register this active entity to the correponding Inspection::Report instance object so that it can .
				class ActiveEntityObserver < Sketchup::ModelObserver

					include Utils::Constants

					def onActivePathChanged(model)
						entity = model.active_path.last
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
					end

					private

					def get_entity_type(entity)
						entity.get_attribute(DICT_NAME, DICT_KEY_TYPE)
					end

					def handle_structure_report(entity)
						# There is a chance that this method is triggered but an active structure has already existed in Report
						# (for example: when the user exited the element_manager group onto the structure group). We dont want to
						# make another structure object but we do have to set clear the element_manager in Report in case the user
						# clicked another element manager.
						return State.active_element_manager = nil if State.active_structure
						# TODO: it is better if the hired_contractor is establish once when the user open a new model
						State.active_contractor = ContractorCompany.new(Itb.new(entity))
						State.active_structure = State.active_contractor.structure
					end

					def handle_element_manager_report(entity)
						return State.active_element = nil if State.active_element_manager
						element_manager_name = entity.get_attribute(DICT_NAME, DICT_KEY_ELEMENT_MANAGER_NAME)
						State.active_element_manager = State.active_structure[element_manager_name]
					end

					def handle_element_report(entity)
						return State.active_component = nil if State.active_element
						element_id = entity.get_attribute(DICT_NAME, DICT_KEY_ELEMENT_ID)
						State.active_element = State.active_element_manager[element_id]
					end

					def handle_component_report(entity)
						component_id = entity.get_attribute(DICT_NAME, DICT_KEY_COMPONENT_ID)
						State.active_component = State.active_element[component_id]
					end

					def clear_report
						State.active_structure = nil
					end

				end
			end
    end
  end
end