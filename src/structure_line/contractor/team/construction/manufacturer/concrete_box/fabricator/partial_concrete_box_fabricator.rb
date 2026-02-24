module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction
          module Manufacturer
            module ConcreteBoxManufacturer
              module PartialConcreteBoxFabricator
                extend self

                def fabricate(concrete_box)
                  @concrete_box = concrete_box
                  establish_construction_data
                  divide_concrete_box
                end

                private

                def establish_construction_data
                  @height = @concrete_box.vector.length
                  @divider = 8
                  @course_height = 2*@height/@divider
                  @num_of_box = @divider/2
                end

                def divide_concrete_box
                  ep = @concrete_box.pts.clone
                  @num_of_box.times do
                    extrude_face(ep.clone, @course_height/2)
                    ep.map! {|pt| pt.offset(@concrete_box.vector, @course_height)}
                  end
                end

                def extrude_face(ep, height)
                  base_face = @concrete_box.entities.add_face(ep)
                  base_face.reverse! unless base_face.normal.samedirection?(@concrete_box.vector)
                  base_face.pushpull(height)
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
end