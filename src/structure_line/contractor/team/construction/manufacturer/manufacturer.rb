module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          # A manufacturer's job is to create a component's 3D model and assign it's material
          module Manufacturer
            extend self
            include Utils::Constants

            COMPONENT_TYPE_MAP = {
              COMPONENT_TYPE_BRICK => :manufacture_brick,
              COMPONENT_TYPE_CONCRETE_BOX => :manufacture_concrete_box,
              COMPONENT_TYPE_REBAR => :manufacture_rebar
            }

            def begin_manufacture(element)
              @element = element
              iterate_all_components
            end

            private

            def iterate_all_components
              @element.each_component do |component|
                pick_component_manufacturer(component) unless component.is_hidden?
              end
            end

            def pick_component_manufacturer(component)
              method = COMPONENT_TYPE_MAP[component.type]
              raise ArgumentError, "Manufacturer does not recognized component type" unless method
              send(method, component)
            end

            def manufacture_brick(brick)
              BrickManufacturer.begin_manufacture(brick)
            end

            def manufacture_concrete_box(concrete_box)
              ConcreteBoxManufacturer.begin_manufacture(concrete_box)
            end

            def manufacture_rebar(rebar)
              RebarManufacturer.begin_manufacture(rebar)
            end
          end
        end
      end
    end
  end
end