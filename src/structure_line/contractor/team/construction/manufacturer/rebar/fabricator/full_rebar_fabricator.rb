require_relative '../../../../design/calculation'

module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module RebarManufacturer
              module FullRebarFabricator
                extend self

                include Utils::Constants
                include Design::Calculation

                def fabricate(rebar)
                  @rebar = rebar
                  create_path
                  create_profile_face
                  extrude_profile_face
                  soften_edges
                  delete_path
                end

                private

                def create_path
                  @path = @rebar.entities.add_edges(@rebar.pts)
                end

                def create_profile_face
                  rebar_vector = @rebar.origin_vector
                  pts = arc_points(@rebar.origin_point, rebar_vector, @rebar.diameter/2, 0.degrees, 360.degrees, 12,
                                   perpendicular_vector(rebar_vector))
                  @profile_face = @rebar.entities.add_face(pts)
                  @profile_face.reverse! unless @profile_face.normal.samedirection?(rebar_vector)
                end

                def extrude_profile_face
                  @profile_face.followme(@path)
                end

                def soften_edges
                  @rebar.each_edge do |edge|
                    edge.soft = true
                    edge.smooth = true
                  end
                end

                def delete_path
                  @path.each {|edge| edge.erase!}
                end


              end
            end
          end
        end
      end
    end
  end
end