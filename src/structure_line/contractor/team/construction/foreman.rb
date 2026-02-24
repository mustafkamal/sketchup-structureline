module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          class Foreman
            include Fabricator
            include Manufacturer
            include Utils::Constants

            def initialize(structure)
              @structure = structure
            end

            def build_structure
              # In order to make 3D models inside a nested group, it is better to make the elements 3D model
              # immediately after we establish its manager groups (dont establish the manager's groups all at once).
              # Sketchup's geometry operation sometimes will delete other groups in the same nested group.
              @structure.each_element_manager do |element_manager|
                establish_element_manager_group(element_manager)
                build_elements_inside_manager(element_manager)
              end
            end

            private

            def establish_element_manager_group(element_manager)
              element_manager.establish_groups
            end

            def build_elements_inside_manager(element_manager)
              element_manager.elements.each_value do |element|
                element.establish_group
                handle_fabricator_selection(element)
              end
            end

            def handle_fabricator_selection(element)
              # If the element's presentation is 'simple' then there will be no 3D model of any of its components. We
              # will just pass it to the SimpleFabricator.
              return pass_to_simple_fabricator(element) if element.simple_presentation?
              pass_to_manufacturer(element)
            end

            def pass_to_simple_fabricator(element)
              SimpleFabricator.begin_fabrication(element)
            end

            def pass_to_manufacturer(element)
              Manufacturer.begin_manufacture(element)
            end

          end
        end
      end
    end
  end
end