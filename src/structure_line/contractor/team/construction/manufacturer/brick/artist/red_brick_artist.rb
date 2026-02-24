module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module BrickManufacturer
              module RedBrickArtist
                extend self

                include Environment::Material::Library

                def paint(brick)
                  @brick = brick
                  material = Sketchup.active_model.materials[MATERIAL_NAME_RED_BRICK]
                  @brick.each_face do |face|
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