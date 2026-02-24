module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Element
          module NodeElement

            def position
              self.node.position.offset(self.offset) || self.node.position
            end

            def position=(new_position)
              self.offset = self.position.vector_to(new_position)
            end

            def position_established?
              # Ada kemungkinan sebuah element itu dibentuk ketika posisi dia ditentukan
              self.node.position.is_a?(Geom::Point3d)
            end

          end
        end
      end
    end
  end
end