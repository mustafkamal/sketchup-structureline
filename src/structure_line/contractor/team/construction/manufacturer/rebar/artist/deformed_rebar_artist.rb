require_relative '../../../../../../environment/material/library'

module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module RebarManufacturer
              module DeformedRebarArtist
                extend self

                include Environment::Material::Library

                def paint(rebar)
                  @rebar = rebar
                  cylinder_material = Sketchup.active_model.materials[MATERIAL_NAME_REBAR_CYLINDER]
                  end_material = Sketchup.active_model.materials[MATERIAL_NAME_REBAR_END]
                  @rebar.each_face do |face|
                    if end_face?(face)
                      face.material = end_material
                    else
                      face.material = cylinder_material
                    end
                  end
                end

                private

                def end_face?(face)
                  face.normal.samedirection?(@rebar.origin_vector) || face.normal.samedirection?(@rebar.end_vector)
                end

              end
            end
          end
        end
      end
    end
  end
end