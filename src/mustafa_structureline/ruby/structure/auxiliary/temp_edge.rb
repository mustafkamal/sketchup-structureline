module Mustafa
  module StructureLine
    module Structure
      module Auxiliary
        class TempEdge

          def initialize(structure)
            @structure = structure
            create_temp_edge_group
          end

          def create_temp_edge(pt1, pt2)
            @group.entities.add_edges(pt1, pt2)
          end

          def delete_temp_edges
            @group.erase! if @group
          end

          private

          def create_temp_edge_group
            @group = @structure.entities.add_group
          end


        end
      end
    end
  end
end