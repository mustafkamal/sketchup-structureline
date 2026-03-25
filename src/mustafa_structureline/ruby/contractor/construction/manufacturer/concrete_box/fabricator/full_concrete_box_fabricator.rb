module Mustafa
  module StructureLine
    module Contractor
      module Construction
        module Manufacturer
          module ConcreteBoxManufacturer
            module FullConcreteBoxFabricator
              extend self

              def fabricate(concrete_box)
                @concrete_box = concrete_box
                extrude_face
                soften_edges
              end

              private

              def extrude_face
                base_face = @concrete_box.entities.add_face(@concrete_box.pts)
                base_face.reverse! unless base_face.normal.samedirection?(@concrete_box.vector)
                base_face.pushpull(@concrete_box.vector.length)
              end

              def soften_edges
                return unless @concrete_box.soft_edge_vector
                @concrete_box.each_edge do |edge|
                  next if need_to_soften?(edge)
                  edge.soft = true
                  edge.smooth = true
                end
              end

              def need_to_soften?(edge)
                vector = edge.start.position.vector_to(edge.end.position)
                vector.perpendicular?(@concrete_box.soft_edge_vector)
              end

            end
          end
        end
      end
    end
  end
end