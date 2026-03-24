require_relative '../../../../../../environment/material/rary'

module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module ConcreteBoxManufacturer
              module PlainConcreteArtist
                extend self

                include Environment::Material::Library

                def paint(concrete_box)
                  @concrete_box = concrete_box
                  material = Sketchup.active_model.materials[MATERIAL_NAME_GRAY_CONCRETE]
                  @concrete_box.each_face do |face|
                    face.material = material
                  end
                end

              end
            end
          end
        end
      end
    end
  end
end