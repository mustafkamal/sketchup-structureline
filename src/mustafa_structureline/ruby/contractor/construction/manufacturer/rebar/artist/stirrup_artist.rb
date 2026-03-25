module Mustafa
  module StructureLine
    module Contractor
      module Construction
        module Manufacturer
          module RebarManufacturer
            module StirrupArtist
              extend self

              include Environment::Material::Library

              def paint(rebar)
                @concrete_box = rebar
                material = MATERIAL_LIBRARY[MATERIAL_NAME_STIRRUP]
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