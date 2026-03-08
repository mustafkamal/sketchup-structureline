module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module BrickManufacturer
              module FullBrickFabricator
                extend self

                def fabricate(brick)
                  @brick = brick
                  create_profile_face
                  extrude_profile_face
                end

                private

                def create_profile_face
                  @profile_face = @brick.entities.add_face(@brick.pts)
                  @profile_face.reverse! unless @profile_face.normal.samedirection?(@brick.vector)
                end

                def extrude_profile_face
                  @profile_face.pushpull(@brick.vector.length)
                end
              end
            end
          end
        end
      end
    end
  end
end